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
///
/// - Note:
/// Types who conform to `UnweightedGraph` must implement the `edge(from:to:directed:)` requirements
/// while maintaining the expected logic, given that they are convenience methods.
/// Follow the notes in the respective methods.
///
/// They could not be implemented in a protocol extension because they require the
/// `E` initializer, and `E` is a generic protocol.
protocol UnweightedGraph: Graph where E: UnweightedEdge {
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - Note: To implement it, use `add(edge:)` with the edge type initializer.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    mutating func edge(_ from: Int, to: Int, directed: Bool)

    /// This is a convenience method that adds an unweighted, undirected
    /// edge between the first occurence of two vertices. O(n).
    ///
    /// - Note: To implement it, use `indices(of:_:)` to retrieve the indices,
    ///         guard that they exist, then create and add the edge.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    mutating func edge(_ from: V, to: V, directed: Bool)
}
