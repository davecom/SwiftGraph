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
public protocol WeightedGraph: Graph where E: WeightedEdge {
    typealias W = E.W

    // MARK: Mutate

    mutating func link(_ source: Int, _ target: Int, directed: Bool, weight: W)
    mutating func link(_ source: N, to target: N, directed: Bool, weight: W)

    // MARK: Find

    func neighbors(_ index: Int) -> [(N, W)]

    // MARK: Minimum-Spanning Tree

    func mst(start: Int) -> [E]?

    // MARK: Dijkstra Algorithm

    func dijkstra(_ root: Int, start distance: W) -> ([W?], [Int: E])
    func dijkstra(from root: N, start distance: W) -> ([W?], [Int: E])
    func dijkstra(_ root: Int, start distance: W) -> ([N: W?], [Int: E])
    func dijkstra(from root: N, start distance: W) -> ([N: W?], [Int: E])
}

extension WeightedGraph {
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public mutating func link(_ source: Int, _ target: Int, directed: Bool = false, weight: W) {
        add(E(source: source, target: target, directed: directed, weight: weight))
    }

    /// This is a convenience method that adds a weighted edge between
    /// the first occurence of two nodes. O(n).
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public mutating func link(_ source: N, to target: N, directed: Bool = false, weight: W) {
        guard let (source, target) = indices(of: source, target) else { return }
        link(source, target, directed: directed, weight: weight)
    }
}

extension WeightedGraph {
    /// Find all of the neighbors of a node at a given index, with weights.
    ///
    /// - parameter index: The index for the node to find the neighbors of.
    /// - returns: An array of tuples including the nodes as the first element and the weights as the second element.
    public func neighbors(_ index: Int) -> [(N, W)] {
        return edges[index].map { (nodes[$0.target], $0.weight) }
    }
}

extension WeightedGraph {
    // It's being redefined identically because it uses the `[(N, W)]` overload of `neighbors(for:)`.
    public var description: String {
        return nodes.indices.map { "\(nodes[$0]) -> \(neighbors($0))\n" }.joined()
    }
}
