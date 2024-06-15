public extension WeightedGraph where V: Hashable, W: Comparable & Numeric  {
        
    /// Computes the minimum-cost spanning arborescence of the graph, starting from the specified root.
    ///
    /// - The algorithm does not modify the graph object it is called on, and will return a new graph object that only contains the vertices reachable
    ///   from the specified root, and the edges that constitute the MSA.
    ///
    /// - Note: It is not guaranteed that the indices of vertices in the result graph are the same as the original graph. Though,
    ///  the references of vertices are the same (no copy or cloning of any vertex is performed). Specifically, if all the vertices of the original graph
    ///  were reachable from `root`, then the indices of all vertices are preserved, otherwise they're altered to accomodate for the underlying
    ///  implementation of Gabow's algorithm.
    ///
    /// - Parameter root: The index of the vertex in `self.vertices` that will be the root of the MSA.
    /// - Returns: A pair `(msa: WeightedGraph<V,W>, minCost: W)`, under the type of `MSAResult`, composed of a new graph
    /// that is the minimum cost spanning arborescence of the graph this method was called on, and the corresponding minimum cost.
    ///
    /// - Throws: `MSAError.graphFormatError(reason: String)`, if the graph this method is called on has at least one undirected edge.
    ///
    /// - Complexity: Time: O(E + V·log(V)), Space: O(E+V)
    func msa(root: Int) throws -> MSAResult<V, W> {
        assert(root >= 0 && root < self.vertexCount)

        var reachable = Set<V>()
        var directMap = [V: Int].init()
        var inverseMap: [Int: Int] = .init()
        var reachableVertexToIndexMap: [V: Int] = .init()
        
        let _ = self.ivBfs(fromIndex: root) { vertexIndex, vertex in
            reachable.insert(vertex)
            reachableVertexToIndexMap[vertex] = vertexIndex
            return false
        }
        
        if reachable.count != self.vertexCount {
            assert(reachable.contains(self.vertices[root])) // O(1)
            
            let reachableGraph = WeightedGraph<V, W>()

            reachable.enumerated().forEach { i, vertex in
                directMap[vertex] = i
                inverseMap[i] = reachableVertexToIndexMap[vertex]!
                let _ = reachableGraph.addVertex(vertex)
            }
                        
            self.edgeList().forEach { edge in
                if reachable.contains(self.vertices[edge.u]) && reachable.contains(self.vertices[edge.v]) {
                    guard let u = directMap[self.vertices[edge.u]],
                          let v = directMap[self.vertices[edge.v]] else { fatalError() }
                    
                    reachableGraph.addEdge(
                        fromIndex: u,
                        toIndex: v,
                        weight: edge.weight,
                        directed: true
                    )
                }
            }
            
            return try reachableGraph.msaFromConnectedRoot(
                directMap[self.vertices[root]]!,
                directMap: directMap,
                inverseMap: inverseMap,
                spansWholeGraph: false
            )
        } else {
            return try msaFromConnectedRoot(
                root, 
                directMap: directMap,
                inverseMap: inverseMap,
                spansWholeGraph: true
            )
        }
    }
    
    private func msaFromConnectedRoot(
        _ root: Int, 
        directMap: [V: Int],
        inverseMap: [Int: Int],
        spansWholeGraph: Bool
    ) throws -> MSAResult<V, W> {
        let gabow = Gabow<W>(verticesCount: self.vertexCount)
        
        try self.edgeList().forEach { edge in
            if !edge.directed {
                throw MSAError.graphFormatError(reason: "Graph must be directed")
            }
                        
            gabow.createEdge(edge.u, edge.v, edge.weight)
        }
        
        let msa = gabow.run(root: root)
        let edges = gabow.reconstruct(root: root)
        
        let msaGraph = WeightedGraph<V, W>(vertices: self.vertices)

        let allEdges = self.edgeList()
        edges.forEach { edgeID in
            assert(edgeID >= 0 && edgeID < allEdges.count)
            
            let newEdge = allEdges[edgeID]
            msaGraph.addEdge(newEdge, directed: true)
        }
        
        assert(msaGraph.edgeList().count == self.vertexCount - 1)
        
        return MSAResult(
            arborescence: msaGraph,
            minCost: msa,
            directMap: directMap,
            inverseMap: inverseMap,
            spansWholeGraph: spansWholeGraph
        )
    }
    
}

public enum MSAError: Error {
    case graphFormatError(reason: String)
}
