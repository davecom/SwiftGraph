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

/// A subclass of UnweightedGraph that ensures there are no pairs of equal vertices and no repeated edges.
open class UniqueElementsGraph<V: Equatable>: UnweightedGraph<V> {

    public override init() {
        super.init()
    }

    /// Init the Graph with vertices, but removes duplicates. O(n^2)
    public override init(vertices: [V]) {
        super.init()
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
        return super.addVertex(v)
    }

    /// Only allow the edge to be added once
    ///
    /// - parameter e: The edge to add.
    public func addEdge(_ e: E) {
        if !edgeExists(from: e.u, to: e.v) {
            edges[e.u].append(e)
        }
    }
    
    /// Only allow the edge to be added once
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public override func addEdge(from: Int, to: Int, directed: Bool = false) {
        if !edgeExists(from: from, to: to) {
            addEdge(UnweightedEdge(u: from, v: to))
            if !directed && !edgeExists(from: to, to: from) {
                addEdge(UnweightedEdge(u: to, v: from))
            }
        }
        
        
    }
    
    /// Only allow the edge to be added once
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public override func addEdge(from: V, to: V, directed: Bool = false) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                if !edgeExists(from: u, to: v) {
                    addEdge(UnweightedEdge(u: u, v: v))
                    if !directed && !edgeExists(from: v, to: u) {
                        addEdge(UnweightedEdge(u: v, v: u))
                    }
                }
                
            }
        }
    }
}
