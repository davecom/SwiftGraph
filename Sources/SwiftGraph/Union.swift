//
//  Union.swift
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

// MARK: - Extension to UniqueVerticesGraph with Union initializer
public extension UniqueElementsGraph {
    
    /// Creates a new UniqueVerticesGraph that is the union of two UniqueVerticesGraphs. O(n^2)
    ///
    /// This operation is commutative in the sense that g1 ∪ g2 has the same vertices and edges
    /// than g2 ∪ g1. However, the indices of the vertices are not guaranteed to be the same.
    ///
    /// - Parameters:
    ///   - lhs: One of the graphs to build the union from.
    ///   - rhs: The other graph to build the union from.
    public convenience init(unionOf lhs: UniqueElementsGraph<V>, _ others: UniqueElementsGraph<V>...) {
        self.init()

        // We know vertices in lhs are unique, so we call Graph.addVertex to avoid the uniqueness check of UniqueElementsGraph.addVertex.
        for vertex in lhs.vertices {
            _ = self.addVertex(vertex)
        }

        // When vertices are removed from Graph, edges can be mutated,
        // so we need to add new copies of them for the result graph.
        for edge in lhs.edges.joined() {
            addEdge(edge)
        }

        for g in others {
            // Vertices in rhs might be equal to some vertex in lhs, so we need to add them
            // with addVertex to guarantee uniqueness.
            for vertex in g.vertices {
                _ = addVertex(vertex)
            }

            for edge in g.edges.joined() {
                addEdge(from: g[edge.u], to: g[edge.v], directed: true)
            }
        }
    }
}
