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
public extension UniqueElementsGraphCustomEdge {
    
    /// Creates a new UniqueVerticesGraph that is the union of several UniqueVerticesGraphs.
    ///
    /// This operation is commutative in the sense that g1 ∪ g2 has the same vertices and edges
    /// than g2 ∪ g1. However, the indices of the vertices are not guaranteed to be conserved.
    ///
    /// This operation is O(k*n^2), where k is the number of graphs and n the number of vertices of
    /// the largest graph.
    ///
    /// - Parameters:
    ///   - graphs: Array of graphs to build the union from.
    public convenience init(unionOf graphs: [UniqueElementsGraphCustomEdge]) {
        self.init()

        guard let firstGraph = graphs.first else { return }
        let others = graphs.dropFirst()

        // We know vertices in lhs are unique, so we call Graph.addVertex to avoid the uniqueness check of UniqueElementsGraph.addVertex.
        for vertex in firstGraph.vertices {
            _ = addVertex(vertex)
        }

        // When vertices are removed from Graph, edges might mutate,
        // so we need to add new copies of them for the result graph.
        for edge in firstGraph.edges.joined() {
            addEdge(edge)
        }

        for g in others {
            // Vertices in rhs might be equal to some vertex in lhs, so we need to add them
            // with self.addVertex to guarantee uniqueness.
            for vertex in g.vertices {
                _ = addVertex(vertex)
            }

            for var edge in g.edges.joined() {
                if let u = indexOfVertex(g[edge.u]), let v = indexOfVertex(g[edge.v]) {
                    edge.u = u
                    edge.v = v
                    addEdge(edge)
                }
            }
        }
    }

    public convenience init(unionOf graphs: UniqueElementsGraphCustomEdge...) {
        self.init(unionOf: graphs)
    }
}
