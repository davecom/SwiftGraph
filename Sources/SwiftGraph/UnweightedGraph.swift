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
    mutating func edge(_ from: Int, to: Int, directed: Bool)
    mutating func edge(_ from: N, to: N, directed: Bool)
}

extension UnweightedGraph {
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public mutating func edge(_ from: Int, to: Int, directed: Bool = false) {
        add(edge: E(source: from, target: to, directed: directed))
    }

    /// This is a convenience method that adds an unweighted, undirected
    /// edge between the first occurence of two nodes. O(n).
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter directed: Is the edge directed? (default `false`)
    public mutating func edge(_ from: N, to: N, directed: Bool = false) {
        guard let (from, to) = indices(of: from, to) else { return }
        edge(from, to: to, directed: directed)
    }
}
