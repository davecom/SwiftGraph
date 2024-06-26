import Foundation

internal final class Gabow<T> where T: AdditiveArithmetic & Comparable & Numeric {
    private let verticesCount: Int
    private let co: CompressedTree<T>
    private var edges: [Gabow.Edge]
    private var incomingEdges: [[Int]]
    private var growthPath: [Int]
    private var pathEdges: [Int]
    private var exitList: [[Int]]
    private var passiveSet: [[Int]]
    private let activeForest: ActiveForest<T>
    
    
    // forest over chosen edges as outlined in reconstruction paper
    private var chosen: [Int]
    private var forest: [Int] // forest[i]: parent in reconstruction forest of edge edges[chosen[i]] (as ids into chosen)
    
    private var contractions: Int = 0

    internal init(verticesCount: Int) {
        self.verticesCount = verticesCount
        
        self.incomingEdges = [[Int]].init()
        self.exitList = [[Int]].init()
        self.passiveSet = [[Int]].init()
                
        for _ in 0..<verticesCount {
            self.incomingEdges.append([Int].init())
            self.exitList.append([Int].init())
            self.passiveSet.append([Int].init())
        }
                 
        let compressedTree = CompressedTree<T>(initialSize: verticesCount)
        
        self.co = compressedTree
        self.activeForest = ActiveForest(co: compressedTree)
        
        self.growthPath = [Int].init()
        self.pathEdges = [Int].init()
                
        self.chosen = [Int].init()
        self.forest = [Int].init()
        self.edges = [Gabow.Edge].init()
    }
    
    
    @inlinable internal func currentWeight(for edge: Edge) -> T {
        return edge.weight + co.findValue(edge.to)
    }
    
    // MARK: - INTERNAL METHODS:
    internal func createEdge(from: Int, to: Int, weight: T) {

        assert(from >= 0 && from < self.verticesCount)
        assert(to >= 0 && to < self.verticesCount)
        
        if from != to {
            self.incomingEdges[to].append(edges.count)
        }
        
        // we save even self loops to keep edge ids consistent with the outside
        edges.append(Gabow.Edge(from: from, to: to, weight: weight))
    }
    
    
    internal func createEdge(_ from: Int, _ to: Int, _ weight: T) {
        self.createEdge(from: from, to: to, weight: weight)
    }
    
    
    internal func run(root: Int) -> T {
        var answer = T.zero
        
        var seen = [Int].init(repeating: -1, count: self.verticesCount)
        
        for vertex in 0..<self.verticesCount {
            if !self.co.same(root, vertex) {
                
                // we start a new path and u is the next vertex that should go on path
                var u: Int = vertex
                
                while !co.same(root, u) {

                    if seen[u] == -1 {
                        self.extendPath(for: u)
                        seen[u] = vertex
                    } else {
                        u = self.contractPathPrefix(u)
                    }
                    
                    // choose next edge
                    let edgeID = self.activeForest.getMin(u)
                    let edge = self.edges[edgeID]

                    // print("+ \(edge.from) --\(edge.weight)--> \(edge.to)")
                    answer += self.currentWeight(for: edge)
                    
                    let forestID = self.chosen.count
                    self.chosen.append(edgeID)
                    self.forest.append(forestID)  // new edge initially has no parent
                    self.pathEdges.append(forestID)
                    
                    u = co.find(edge.from)
                }
                
                self.contractCompletePath(root: root)
            }
        }
        return answer
    }

    
    internal func getEdges() -> [Gabow.Edge] {
        return self.edges
    }
    
    // MARK: - PRIVATE METHODS
    private func contractPathPrefix(_ root: Int) -> Int {
        self.contractions += 1
        
        #if DEBUG
            assert(co.find(root) == root);
            assert(growthPath.count == pathEdges.count);
        #endif
        
        var prefix: [Int] = [Int].init()
        
        repeat {
            guard let vi = self.growthPath.last else {
                fatalError("In function \(#function), `growthPath` is unexpectedly empty")
            }
            
            guard let lastPathEdge = self.pathEdges.last else {
                fatalError("In function \(#function), `lastPathEdge` is unexpectedly empty")
            }
            
            #if DEBUG
                // all nodes on growth path are representatives
                assert(co.find(vi) == vi)
            
                // synced with growthPath edges
                assert(co.find(edges[chosen[lastPathEdge]].to) == vi)
            #endif
            
            prefix.append(vi)
            self.co.addValue(
                vi,
                increment: self.currentWeight(
                    for: edges[ self.chosen[lastPathEdge] ]
                )*(-1)
            )
            
            // next iteration in run will find an incoming edge into the here contracted prefix; this edge will be the next in chosen
            self.forest[lastPathEdge] = self.chosen.count
            
            self.growthPath.removeLast()
            self.pathEdges.removeLast()
            
        } while prefix.last != root
        
        // delete outgoing edges
        prefix.forEach { prefixVertex in
            if !self.exitList[prefixVertex].isEmpty {
                self.exitList[prefixVertex].removeAll() // FIXME: removeAll has linear performance. Replace with new allocation of empty vector
                self.activeForest.deleteActiveEdge(prefixVertex)
            }
        }

        // merge dsu
        prefix.forEach { prefixVertex in
            co.join(prefixVertex, root)
        }
        
        let newRep = co.find(root)
        self.growthPath.append(newRep)

        
        // merge in active forest
        prefix.forEach { prefixVertex in
            if prefixVertex != newRep {
                self.activeForest.mergeHeaps(newRep, prefixVertex)
            }
        }
        
        
        // condense all edges into the prefix to at most 1 per origin
        prefix.forEach { prefixVertex in
            // if we are here then there are no passive edges to any node earlier in prefix than prefixVertex
            self.passiveSet[prefixVertex].reverse()
                
            passiveSet[prefixVertex].forEach { edgeID in
                let edge = edges[edgeID]
                let from = co.find(edge.from)
                
                if from == newRep {
                    return
                }
                
                if let lastFromExitListEdge = self.exitList[from].last {
                    let firstEdgeID = lastFromExitListEdge
                    let firstEdge = self.edges[firstEdgeID]
                    
                    #if DEBUG
                    // the exit list of 'from' should have 'edge' as the first passive edge (just after the active 'first_edge')
                    // since all passive edges from nodes v0...v_{i-1} were deleted
                    // with multi-edges this depends on the fact that edge order in exit_list[from] has edges to vi in same order as they are in passive_set[prefixVertex]
                        let reversedFromExitList = self.exitList[from].reversed()
                        
                        assert(self.exitList[from].count >= 2) // namely first_edge and edge
                        assert(reversedFromExitList.first { exitListEdge in
                            return exitListEdge == edgeID
                        } == self.exitList[from][self.exitList[from].count - 2])
                    #endif
                    
                    self.exitList[from].removeLast()
                    
                    if self.currentWeight(for: firstEdge) > self.currentWeight(for: edge) {
                        self.activeForest.makeActive(
                            from: edge.from,
                            to: edge.to,
                            weight: edge.weight,
                            id: edgeID
                        )
                    } else {
                        self.exitList[from][self.exitList[from].count - 1] = firstEdgeID
                    }
                }
            }
            
            self.passiveSet[prefixVertex].removeAll() // FIXME: Replace with empty allocated vector for performance reasons
        }
        
        return newRep
    }
    
    
    private func contractCompletePath(root: Int) {
        let rootRep = self.co.find(root)
        
        self.growthPath.forEach { vertex in
            self.co.join(vertex, rootRep)
        }
        
        // merge all into old rootRep
        self.growthPath.forEach { vertex in
            self.activeForest.mergeHeaps(rootRep, vertex)
        }
        
        // then move to new root_rep
        if rootRep != self.co.find(rootRep) {
            self.activeForest.mergeHeaps(self.co.find(rootRep), rootRep)
        }
        
        self.growthPath.removeAll() // FIXME: Replace with empty allocated vector for performance
        self.pathEdges.removeAll() // FIXME: Replace with empty allocated vector for performance
    }
   
    
    internal func reconstruct(root: Int) -> [Int] {
        let n = self.chosen.count
        
        // build leafs arary (first chosen edge for each node)
        var leaf = [Int].init(repeating: -1, count: self.verticesCount)
        
        for i in 0..<n {
            let edge = self.edges[ self.chosen[i] ]
            
            if leaf[edge.to] == -1 {
                leaf[ edge.to ] = i
            }
        }
        
        leaf[ root ] = -2
        
        #if DEBUG
        // assert each node has an incoming edge
        assert(
            leaf.reduce(true, { noEmpty, nextLeaf in
                return noEmpty && nextLeaf != -1
            }) == true
        ); // assert each node has an incoming edge
        #endif
        
        var res: [Int] = .init()
        var del: [Bool] = .init(repeating: false, count: n)
        
        // we exploit here that parent has always higher index; -> larger index first results in top-to-bottom traversal
        
        let reversedRange = (0..<n).reversed()
        for r in reversedRange {
            if !del[r] {
                assert(forest[r]==r || del[forest[r]])
                
                let edge = self.edges[ self.chosen[r] ]
                if edge.to != root {
                    res.append(self.chosen[r])
                }
                
                let leafEdgePos = leaf[edge.to]
                
                // we take the edge at position r and 'delete' the path from the leaf to the root from the forest
                del[r] = true
                
                var i = leafEdgePos
                while(i != r) {
                    del[i] = true
                    i = forest[i]
                }
            }
        }
        
        assert(res.count == self.verticesCount - 1);
        return res
    }
    
    
    private func extendPath(for vertex: Int) {

        #if DEBUG
        assert(co.find(vertex) == vertex)
        #endif
        
        self.growthPath.append(vertex)
        
        self.incomingEdges[vertex].forEach { edgeID in
            let edge = self.edges[edgeID]
            let repX = co.find(edge.from)
            
            if !self.exitList[repX].isEmpty {
                
                guard let frontEdgeID = self.exitList[repX].last else {
                    fatalError("In function \(#function), unexpectedly found empty exitList[repX]")
                }
                
                let frontEdge = self.edges[frontEdgeID]
                
                if vertex != frontEdge.to {
                    // keep both frontedge and edge
                    self.passiveSet[co.find(frontEdge.to)].append(frontEdgeID)
                } else {
                    // we can use weight here since u was never contracted
                    if edge.weight < frontEdge.weight {
                        // discard previous front edge
                        self.exitList[repX].removeLast()
                    } else {
                        return
                    }
                }
            }
            
            self.exitList[repX].append(edgeID)
            self.activeForest.makeActive(from: edge.from, to: edge.to, weight: edge.weight, id: edgeID)
        }
        
    }

    
    internal struct Edge {
        internal let from: Int
        internal let to: Int
        internal let weight: T
        
        internal init(from: Int, to: Int, weight: T) {
            self.from = from
            self.to = to
            self.weight = weight
        }
    }
}


