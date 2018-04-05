//
//  UniqueVerticesGraph.swift
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

/// A subclass of UnweightedGraph that ensures there are no pairs of equal vertices.
open class UniqueVerticesGraph<V: Equatable>: UnweightedGraph<V> {

    public override init() {
        super.init()
    }

    /// Init the Graph with vertices, but removes duplicates.
    public override init(vertices: [V]) {
        super.init(vertices: vertices)
    }

    /// Add a vertex to the graph if no equal vertex already belongs to the Graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added, or the index of the first equal vertex already belonging to the graph.
    public override func addVertex(_ v: V) -> Int {
        if let equalVertexIndex = vertices.index(where: { $0 == v }) {
            return equalVertexIndex
        }
        return super.addVertex(v)
    }
}
