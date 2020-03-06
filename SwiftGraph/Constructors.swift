//
//  Constructors.swift
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

/// A type used to construct an UnweightedGraph with vertices of type V that is isomorphic to a star graph.
/// https://en.wikipedia.org/wiki/Star_(graph_theory)
public enum StarGraph<V: Equatable & Codable> {

    /// Constructs an undirected UnweightedGraph isomorphic to a star graph.
    ///
    /// - Parameters:
    ///   - center: The vertex that is connected to all vertices except itself.
    ///   - leafs: The set of vertices that are connected only to the center vertex.
    /// - Returns: An UnweightedGraph star graph with the center vertex connected to all the leafs. The leafs
    ///            are only connected to the center
    public static func build(withCenter center: V, andLeafs leafs: [V]) -> UnweightedGraph<V> {
        let g = UnweightedGraph<V>(vertices: [center] + leafs)

        guard leafs.count > 0 else { return g }
        for i in 1...leafs.count {
            g.addEdge(fromIndex: 0, toIndex: i)
        }
        return g
    }
}


/// A type used to construct UnweightedGraph with vertices of type V that is isomorphic to a complete graph.
/// https://en.wikipedia.org/wiki/Complete_graph
public enum CompleteGraph<V: Equatable & Codable> {

    /// Constructs an undirected UnweightedGraph isomorphic to a complete graph.
    ///
    /// - Parameter vertices: The set of vertices of the graph.
    /// - Returns: An UnweightedGraph complete graph, a graph with each vertex connected to all the vertices except itself.
    public static func build(withVertices vertices: [V]) -> UnweightedGraph<V> {
        let g = UnweightedGraph<V>(vertices: vertices)

        for i in 0..<vertices.count {
            for j in 0..<i {
                g.addEdge(fromIndex: i, toIndex: j)
            }
        }
        return g
    }
}
