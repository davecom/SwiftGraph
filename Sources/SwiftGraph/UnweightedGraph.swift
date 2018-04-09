//
//  UnweightedGraph.swift
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

/// A graph with `UnweightedEdge`.
public protocol UnweightedGraph: Graph where E: UnweightedEdge {
    mutating func link(_ source: Int, _ target: Int, directed: Bool)
    mutating func link(_ source: N, to target: N, directed: Bool)
}

extension UnweightedGraph {
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public mutating func link(_ source: Int, _ target: Int, directed: Bool = false) {
        add(E(source: source, target: target, directed: directed))
    }

    /// This is a convenience method that adds an unweighted, undirected
    /// edge between the first occurence of two nodes. O(n).
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter directed: Is the edge directed? (default `false`)
    public mutating func link(_ source: N, to target: N, directed: Bool = false) {
        guard let (source, target) = indices(of: source, target) else { return }
        link(source, target, directed: directed)
    }
}
