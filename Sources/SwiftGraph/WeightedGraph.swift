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

/// A graph with `WeightedEdge`.
///
/// - Note:
/// Types who conform to `UnweightedGraph` must implement the `edge(from:to:directed:weight:)` requirements
/// while maintaining the expected logic, given that they are convenience methods.
/// Follow the notes in the respective methods.
///
/// They could not be implemented in a protocol extension because they require the
/// `E` initializer, and `E` is a generic protocol.
public protocol WeightedGraph: Graph where E: WeightedEdge {
    typealias W = E.W

    // MARK: Mutate

    /// This is a convenience method that adds a weighted edge.
    ///
    /// - Note: To implement it, use `add(edge:)` with the edge type initializer.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    mutating func edge(_ from: Int, to: Int, directed: Bool, weight: W)

    /// This is a convenience method that adds a weighted edge between
    /// the first occurence of two vertices. O(n).
    ///
    /// - Note: To implement it, use `indices(of:_:)` to retrieve the indices,
    ///         guard that they exist, then create and add the edge.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    mutating func edge(_ from: V, to: V, directed: Bool, weight: W)

    // MARK: Find

    func neighbors(for index: Int) -> [(V, W)]

    // MARK: Minimum-Spanning Tree

    func mst(start: Int) -> [E]?

    // MARK: Dijkstra Algorithm

    func dijkstra(root: Int, start distance: W) -> ([W?], [Int: E])
    func dijkstra(root: V, start distance: W) -> ([W?], [Int: E])
    func dijkstra(root: Int, start distance: W) -> ([V: W?], [Int: E])
    func dijkstra(root: V, start distance: W) -> ([V: W?], [Int: E])
}

extension WeightedGraph {
    /// Find all of the neighbors of a vertex at a given index, with weights.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of tuples including the vertices as the first element and the weights as the second element.
    public func neighbors(for index: Int) -> [(V, W)] {
        var distanceTuples: [(V, W)] = [(V, W)]()
        for edge in edges[index] {
            distanceTuples += [(vertices[edge.v], edge.weight)]
        }
        return distanceTuples
    }
}

extension WeightedGraph {
    public var description: String {
        var d: String = ""
        for i in 0 ..< vertices.count {
            d += "\(vertices[i]) -> \(neighbors(for: i))\n"
        }
        return d
    }
}
