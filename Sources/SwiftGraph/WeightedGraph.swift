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
open class WeightedGraph<V: Equatable, W: Equatable>: Graph {
    public var vertices: [V] = [V]()
    public var edges: [[WeightedEdge<W>]] = [[WeightedEdge<W>]]() //adjacency lists
    
    public init() {
    }
    
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
}

extension Graph where E: WeightedEdgeProtocol {
    public typealias W = E.Weight

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
    public func addEdge(fromIndex: Int, toIndex: Int, weight:W, directed: Bool = false) {
        addEdge(E(u: fromIndex, v: toIndex, weight: weight), directed: directed)
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: V, to: V, weight: W, directed: Bool = false) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(fromIndex: u, toIndex: v, weight: weight, directed: directed)
        }
    }

    /// Check whether there is an edge from one vertex to another vertex with a specific weight.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: Int, to: Int, withWeight weight: W) -> Bool {
        return edgeExists(E(u: from, v: to, weight: weight))
    }

    /// Check whether there is an edge from one vertex to another vertex with a specific weight.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V, withWeight weight: W) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(from: u, to: v, withWeight: weight)
            }
        }
        return false
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: Int, to: Int) -> Bool {
        return edges[from].map({$0.v}).contains(to)
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
                return edgeExists(from: u, to: v)
            }
        }
        return false
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
    
    required public init(vertices: [V]) {
        super.init(vertices: vertices)
    }

    public convenience init(fromGraph g: WeightedGraph<V, W>) {
        self.init()
        vertices = g.vertices
        edges = g.edges
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
