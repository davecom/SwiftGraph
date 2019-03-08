//
//  UniqueElementsGraph.swift
//  SwiftGraph
//
//  Copyright (c) 2018 Ferran Pujol Camins
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

public typealias UnweightedUniqueElementsGraph<V: Equatable> = UniqueElementsGraph<V, UnweightedEdge>

/// A subclass of UnweightedGraph that ensures there are no pairs of equal vertices and no repeated edges.
open class UniqueElementsGraph<V: Equatable, E: Edge&Equatable>: Graph {
    public var vertices: [V] = [V]()
    public var edges: [[E]] = [[E]]() //adjacency lists

    public init() {
    }

    /// Init the Graph with vertices, but removes duplicates. O(n^2)
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex) // make sure to call our version
        }
    }
    
    /// Add a vertex to the graph if no equal vertex already belongs to the Graph. O(n)
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added, or the index of the equal vertex already belonging to the graph.
    public func addVertex(_ v: V) -> Int {
        if let equalVertexIndex = indexOfVertex(v) {
            return equalVertexIndex
        }
        vertices.append(v)
        edges.append([E]())
        return vertices.count - 1
    }

    /// Add an edge to the graph. Only allow the edge to be added once
    ///
    /// - parameter e: The edge to add.
    /// - parameter directed: If false, undirected edges are created.
    ///                       If true, a reversed edge is also created.
    ///                       Default is false.
    public func addEdge(_ e: E, directed: Bool = false) {
        if !self.edgeExists(e) {
            edges[e.u].append(e)
        }
        if !directed {
            let reversedEdge = e.reversed()
            if !edgeExists(reversedEdge) {
                edges[e.v].append(reversedEdge)
            }
        }
    }
}

extension UniqueElementsGraph where E == UnweightedEdge {

    private func addEdgesForPath(withIndices indices: [Int], directed: Bool) {
        for i in 0..<indices.count - 1 {
            addEdge(fromIndex: indices[i], toIndex: indices[i+1], directed: directed)
        }
    }

    /// Is there an edge from one vertex to another?
    ///
    /// - parameter from: The index of the starting edge.
    /// - parameter to: The index of the ending edge.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edgeExists(from: Int, to: Int) -> Bool {
        return edgeExists(E(u: from, v: to))
    }

    /// Is there an edge from one vertex to another? Note this will look at the first occurence of each vertex. Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The first vertex.
    /// - parameter to: The second vertex.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edgeExists(from: V, to: V) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(from: u, to: v)
            }
        }
        return false
    }

    /// Only allow the edge to be added once
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(fromIndex u: Int, toIndex v: Int, directed: Bool = false) {
        addEdge(UnweightedEdge(u: u, v: v), directed: directed)
    }

    /// Only allow the edge to be added once
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: V, to: V, directed: Bool = false) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(fromIndex: u, toIndex: v, directed: directed)
        }
    }

    /// Initialize an UniqueElementsGraph consisting of path.
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
    public convenience init(withPath path: [V], directed: Bool = false) {
        self.init(vertices: path)

        guard path.count >= 2 else {
            return
        }

        let indices = path.map({ indexOfVertex($0)! })
        addEdgesForPath(withIndices: indices, directed: directed)
    }

    /// Initialize an UniqueElementsGraph consisting of cycle.
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
    public convenience init(withCycle cycle: [V], directed: Bool = false) {
        self.init(vertices: cycle)

        guard cycle.count >= 2 else {
            if let v = cycle.first {
                let index = addVertex(v)
                addEdge(fromIndex: index, toIndex: index)
            }
            return
        }

        let indices = cycle.map({ indexOfVertex($0)! })
        addEdgesForPath(withIndices: indices, directed: directed)
        addEdge(fromIndex: indices.last!, toIndex: indices.first!, directed: directed)
    }

}

extension UniqueElementsGraph where V: Hashable, E == UnweightedEdge {
    public convenience init(withPath path: [V], directed: Bool = false) {
        self.init()

        guard path.count >= 2 else {
            if let v = path.first {
                _ = addVertex(v)
            }
            return
        }

        let indices = indicesForPath(path)
        addEdgesForPath(withIndices: indices, directed: directed)
    }


    public convenience init(withCycle cycle: [V], directed: Bool = false) {
        self.init()

        guard cycle.count >= 2 else {
            if let v = cycle.first {
                let index = addVertex(v)
                addEdge(fromIndex: index, toIndex: index)
            }
            return
        }

        let indices = indicesForPath(cycle)
        addEdgesForPath(withIndices: indices, directed: directed)
        addEdge(fromIndex: indices.last!, toIndex: indices.first!, directed: directed)
    }

    private func indicesForPath(_ path: [V]) -> [Int] {
        var indices: [Int] = []
        var indexForVertex: Dictionary<V, Int> = [:]

        for v in path {
            if let index = indexForVertex[v] {
                indices.append(index)
            } else {
                let index = addVertex(v)
                indices.append(index)
                indexForVertex[v] = index
            }
        }
        return indices
    }
}
