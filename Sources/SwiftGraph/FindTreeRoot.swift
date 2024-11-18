import Foundation

fileprivate class UnionFind {
    private var parent: [Int]
    private var rank: [Int]
    
    init(elements: [Int]) {
        self.parent = [Int].init(repeating: 0, count: elements.count)
        self.rank = [Int].init(repeating: 0, count: elements.count)
        
        self.makeSet(elements)
    }

    private final func makeSet(_ vertices: [Int]) {
        for i in 0..<vertices.count {
            parent[i] = i
            rank[i] = 0
        }
    }

    func find(_ x: Int) -> Int {
        if parent[x] != x {
            parent[x] = find(parent[x]) // Path compression
        }
        return parent[x]
    }

    func union(_ x: Int, _ y: Int) {
        let xRoot = find(x)
        let yRoot = find(y)
        
        if xRoot == yRoot {
            return
        }
        
        if rank[xRoot] < rank[yRoot] {
            parent[xRoot] = yRoot
        } else if rank[xRoot] > rank[yRoot] {
            parent[yRoot] = xRoot
        } else {
            parent[yRoot] = xRoot
            rank[xRoot] += 1
        }
    }
}


extension Graph {
    /// If this graph is a valid tree, this algorihtm finds and returns the index of the root vertex in `self.vertices`.
    ///
    /// May require further testing.
    ///
    /// - Returns: The index of of the root of the tree, if this `self` is a tree, `nil` otherwise. If the graph is a degenerate tree,
    /// i.e. an empty tree, this function returns nil.
    ///
    /// - Complexity: **Time:** O(V + E⋅α(V)) where α(V) is the inverse Ackermann function, that grows extremely slowly (it is considered
    /// constant for any common practical application). **Memory:** O(V) to create the sets for Union-Find by rank with path compression.
    public func findTreeRoot() -> Int? {
        let unionFind = UnionFind(elements: [Int](self.vertices.indices))
        
        for vertex in 0..<self.vertices.count {
            for neighbor in self.edges[vertex] {
                let rootVertex = unionFind.find(vertex)
                let rootNeighbor = unionFind.find(neighbor.v)
                
                if rootVertex == rootNeighbor {
                    return nil
                }
                
                unionFind.union(rootVertex, rootNeighbor)
            }
        }

        var roots = Set<Int>()
        for vertex in 0..<self.vertices.count {
            roots.insert(unionFind.find(vertex))
        }
    
        if roots.count == 1 {
            return roots.first
        } else {
            return nil
        }
    }
    
    
    
    public func findTreeRootVertex() -> V? {
        guard let root = findTreeRoot() else {
            return nil
        }
        
        return self.vertices[root]
    }
}
