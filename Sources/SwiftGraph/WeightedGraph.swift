//
//  WeightedGraph.swift
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

/// A subclass of Graph that has convenience methods for adding and removing WeightedEdges. All added Edges should have the same generic Comparable type W as the WeightedGraph itself.
open class WeightedGraph<V: Equatable, W: Comparable & Numeric & Codable>: Graph {
    public var vertices: [V] = [V]()
    public var edges: [[WeightedEdge<W>]] = [[WeightedEdge<W>]]() //adjacency lists
    
    public init() {
    }
    
    public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of tuples including the vertices as the first element and the weights as the second element.
    public func neighborsForIndexWithWeights(_ index: Int) -> [(V, W)] {
        var distanceTuples: [(V, W)] = [(V, W)]();
        for edge in edges[index] {
            distanceTuples += [(vertices[edge.v], edge.weight)]
        }
        return distanceTuples;
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: Int, to: Int, weight:W, directed: Bool = false) {
        addEdge(WeightedEdge<W>(u: from, v: to, weight: weight))
        if !directed {
            addEdge(WeightedEdge<W>(u: to, v: from, weight: weight))
        }
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: V, to: V, weight: W, directed: Bool = false) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(from: u, to: v, weight: weight, directed: directed)
            }
        }
    }
    
    //Implement Printable protocol
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))\n"
        }
        return d
    }
}

public final class CodableWeightedGraph<V: Codable & Equatable, W: Comparable & Numeric & Codable> : WeightedGraph<V, W>, Codable {
    enum CodingKeys: String, CodingKey {
        case vertices = "vertices"
        case edges = "edges"
    }
    
    override public init() {
        super.init()
    }
    
    override public init(vertices: [V]) {
        super.init(vertices: vertices)
    }
    
    public required init(from decoder: Decoder) throws  {
        super.init()
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.vertices = try rootContainer.decode([V].self, forKey: CodingKeys.vertices)
        self.edges = try rootContainer.decode([[E]].self, forKey: CodingKeys.edges)
    }
    
    public func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        try rootContainer.encode(self.vertices, forKey: CodingKeys.vertices)
        try rootContainer.encode(self.edges, forKey: CodingKeys.edges)
    }
}
