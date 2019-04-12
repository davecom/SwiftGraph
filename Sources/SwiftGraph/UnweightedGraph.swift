//
//  UnweightedGraph.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2019 David Kopec
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

/// An implementation of Graph with some convenience methods for adding and removing UnweightedEdges. WeightedEdges may be added to an UnweightedGraph but their weights will be ignored.
open class UnweightedGraph<V: Equatable & Codable>: Graph {
    public var vertices: [V] = [V]()
    public var edges: [[UnweightedEdge]] = [[UnweightedEdge]]() //adjacency lists
    
    public init() {
    }
    
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    /// Add an edge to the graph.
    ///
    /// - parameter e: The edge to add.
    /// - parameter directed: If false, undirected edges are created.
    ///                       If true, a reversed edge is also created.
    ///                       Default is false.
    public func addEdge(_ e: UnweightedEdge, directed: Bool) {
        edges[e.u].append(e)
        if !directed && e.u != e.v {
            edges[e.v].append(e.reversed())
        }
    }
    
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added.
    public func addVertex(_ v: V) -> Int {
        vertices.append(v)
        edges.append([E]())
        return vertices.count - 1
    }
}

extension Graph where E == UnweightedEdge {

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
    public static func withPath(_ path: [V], directed: Bool = false) -> Self {
        let g = Self(vertices: path)

        guard path.count >= 2 else {
            return g
        }

        for i in 0..<path.count - 1 {
            g.addEdge(fromIndex: i, toIndex: i+1, directed: directed)
        }
        return g
    }

    /// Initialize an UnweightedGraph consisting of cycle.
    ///
    /// The resulting graph has the vertices in cycle and an edge between
    /// each pair of consecutive vertices in cycle,
    /// plus an edge between the last and the first vertices.
    ///
    /// If cycle is an empty array, the resulting graph is the empty graph.
    /// If cycle is an array with a single vertex, the resulting graph has the vertex
    /// and a single edge to itself if directed is true.
    /// If directed is false the resulting graph has the vertex and two edges to itself.
    ///
    /// - Parameters:
    ///   - cycle: An array of vertices representing a cycle.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in cycle.
    ///               Default is false.
    public static func withCycle(_ cycle: [V], directed: Bool = false) -> Self {
        let g = Self.withPath(cycle, directed: directed)
        if cycle.count > 0 {
            g.addEdge(fromIndex: cycle.count-1, toIndex: 0, directed: directed)
        }
        return g
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(fromIndex: Int, toIndex: Int, directed: Bool = false) {
        addEdge(UnweightedEdge(u: fromIndex, v: toIndex, directed: directed), directed: directed)
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: V, to: V, directed: Bool = false) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(UnweightedEdge(u: u, v: v, directed: directed), directed: directed)
        }
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(fromIndex: Int, toIndex: Int) -> Bool {
        // The directed property of this fake edge is ignored, since it's not taken into account
        // for equality.
        return edgeExists(E(u: fromIndex, v: toIndex, directed: true))
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(fromIndex: u, toIndex: v)
            }
        }
        return false
    }
}
