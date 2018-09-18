//
//  UnweightedGraph.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2016 David Kopec
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

/// A subclass of Graph with some convenience methods for adding and removing UnweightedEdges. WeightedEdges may be added to an UnweightedGraph but their weights will be ignored.
open class UnweightedGraph<T: Equatable & Codable>: Graph<T> {
    public override init() {
        super.init()
    }
    
    public override init(vertices: [T]) {
        super.init(vertices: vertices)
    }


    /// Initialize an UnweightedGraph consisting of path.
    ///
    /// The resulting graph has the vertices in path and an edge between
    /// each pair of consecutive vertices in path.
    ///
    /// If path is an empty array, the resulting graph is the empty graph.
    /// If path is an array with a single vertex, the resulting graph has that vertex and no edges.
    ///
    /// - Parameters:
    ///   - path: An array of vertices representing a path.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in path.
    ///               Default is false.
    public convenience init(withPath path: [T], directed: Bool = false) {
        self.init(vertices: path)

        guard path.count >= 2 else {
            return
        }

        for i in 0..<path.count - 1 {
            let vertices = path[i...i+1]
            self.addEdge(from: vertices.first!, to: vertices.last!, directed: directed)
        }
    }

    /// Initialize an UnweightedGraph consisting of cycle.
    ///
    /// The resulting graph has the vertices in cycle and an edge between
    /// each pair of consecutive vertices in cycle,
    /// plus an edge between the last and the first vertices.
    ///
    /// If path is an empty array, the resulting graph is the empty graph.
    /// If path is an array with a single vertex, the resulting graph has the vertex
    /// and a single edge to itself if directed is true.
    /// If directed is false the resulting graph has the vertex and two edges to itself.
    ///
    /// - Parameters:
    ///   - cycle: An array of vertices representing a cycle.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in cycle.
    ///               Default is false.
    public convenience init(withCycle cycle: [T], directed: Bool = false) {
        self.init(withPath: cycle, directed: directed)
        if cycle.count > 0 {
            self.addEdge(from: cycle.last!, to: cycle.first!, directed: directed)
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: Int, to: Int, directed: Bool = false) {
        addEdge(UnweightedEdge(u: from, v: to, directed: directed))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: T, to: T, directed: Bool = false) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: directed))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific unweighted edge in both directions (if it's not directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public func removeEdge(_ edge: UnweightedEdge) {
        if let i = (edges[edge.u] as! [UnweightedEdge]).index(of: edge) {
            edges[edge.u].remove(at: i)
            if !edge.directed {
                if let i = (edges[edge.v] as! [UnweightedEdge]).index(of: edge.reversed as! UnweightedEdge) {
                    edges[edge.v].remove(at: i)
                }
            }
        }
    }
    
    public required init(from decoder: Decoder) throws  {
        try super.init(from: decoder)
        
        var edgesByVertex:[[UnweightedEdge]] = []

        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        var edgesByVertexIndex = try rootContainer.nestedUnkeyedContainer(forKey: CodingKeys.edges)
        
        while !edgesByVertexIndex.isAtEnd {
            var edgesContainer = try edgesByVertexIndex.nestedUnkeyedContainer()
            let edges: [UnweightedEdge] = try edgesContainer.decode([UnweightedEdge].self)
            edgesByVertex.append(edges)
        }
        self.edges = edgesByVertex
    }
    
    class EdgeDoesNotConformToEncodableError: Error {
        // TODO: which edge
    }
    
    override public func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)

        var rootContainer = encoder.container(keyedBy: CodingKeys.self)

        var edgesByVertexIndex = rootContainer.nestedUnkeyedContainer(forKey: CodingKeys.edges)
        for edgesForVertexIndex in self.edges {
            var edgesForVertex = edgesByVertexIndex.nestedUnkeyedContainer()
            let encodables = try edgesForVertexIndex.map { (edge) -> UnweightedEdge in
                guard let encodable = edge as? UnweightedEdge else {
                    throw EdgeDoesNotConformToEncodableError()
                }
                return encodable
            }
            try edgesForVertex.encode(encodables)
        }
    }
}
