public class MSAResult<V,W> where
        V: Decodable & Encodable & Hashable,
        W: Decodable & Encodable & Equatable & Numeric & Comparable {
    internal let arborescence: WeightedGraph<V, W>
    internal let minCost: W
    internal let directMap: [V: Int]
    internal let inverseMap: [Int: Int]
    internal let _spansWholeGraph: Bool
    
    internal init(
        arborescence: WeightedGraph<V, W>,
        minCost: W,
        directMap: [V: Int],
        inverseMap: [Int: Int],
        spansWholeGraph: Bool
    ) {
        self.arborescence = arborescence
        self.minCost = minCost
        self.directMap = directMap
        self.inverseMap = inverseMap
        self._spansWholeGraph = spansWholeGraph
    }
    
    public func getArborescence() -> WeightedGraph<V, W> {
        return arborescence
    }
    
    public func getMinCost() -> W {
        return minCost
    }
        
    public func spansWholeGraph() -> Bool {
        return self._spansWholeGraph
    }

    /// Finds the mapped index of vertex (as an index in `arborescence.vertices`) in the minimum spanning tree.
    ///
    /// - Parameter vertex: The vertex to find in `arborescence`.
    ///
    /// - Returns: The index of such vertex, if it was reachable from the specified root, `nil` otherwise.
    /// - Complexity: O(1)
    public func findVertex(_ vertex: V) -> Int? {
        return directMap[vertex]
    }
            
    
    /// Finds the index of the specified vertex in the original graph.
    ///
    /// - Parameter indexOfVertex: An index to a vertex in `arborescence.vertices`.
    /// - Returns: If `indexOfVertex` is a valid index in `arborescence.vertices`, it returns the index
    /// of the vertex `arborescence.vertices[indexOfVertex]` in the original graph. Returns `nil` otherwise.
    ///
    /// - Complexity: O(1)
    public func findOriginalIndexOfVertex(_ indexOfVertex: Int) -> Int? {
        return inverseMap[indexOfVertex]
    }
}

