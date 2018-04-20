//
//  DisjointUnion.swift
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

// MARK: - Extension to UniqueVerticesGraph with disjointUnion initializer
public extension UniqueElementsGraph {
    
    /// Creates a new UniqueVerticesGraph that is the disjoint union of two UniqueVerticesGraphs.
    ///
    /// - Parameters:
    ///   - lhs: <#lhs description#>
    ///   - rhs: <#rhs description#>
    public convenience init(disjointUnionOf lhs: UniqueElementsGraph<V>, _ rhs: UniqueElementsGraph<V>) {
        self.init()

        // We know vertices in lhs are unique, so we call Graph.addVertex to avoid the uniqueness check of UniqueElementsGraph.addVertex.
        for vertex in lhs.vertices {
            _ = (self as Graph).addVertex(vertex)
        }

        // When vertices are removed from Graph, edges can be mutated,
        // so we need to add new copies of them for the result graph.
        for edge in lhs.edges.joined() {
            addEdge(from: edge.u, to: edge.v, directed: edge.directed)
        }

        // Vertices in rhs might be equal to some vertex in lhs, so we need to add them
        // with addVertex to guarantee uniqueness.
        for vertex in rhs.vertices {
            _ = addVertex(vertex)
        }

        for edge in rhs.edges.joined() {
            addEdge(from: edge.u, to: edge.v, directed: edge.directed)
        }
    }
}
