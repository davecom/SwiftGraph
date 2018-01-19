//
//  MST.swift
//  SwiftGraph
//
//  Copyright (c) 2017 David Kopec
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

// MARK: Minimum-Spanning Tree (MST)

public extension WeightedGraph {
    // Citation: Based on Algorithms 4th Edition by Sedgewick, Wayne pg 619

    /// Find the minimum spanning tree in a weighted graph. This is the set of edges
    /// that touches every node in the graph and is of minimal combined weight. This function
    /// uses Jarnik's Algorithm (aka Prim's Algorithm) and so assumes the graph has
    /// undirected edges. For a graph with directed edges, the result may be incorrect. Also,
    /// if the graph is not fully connected, the tree will only span the connected component from which
    /// the starting node belongs.
    ///
    /// - parameter start: The index of the node to start creating the MST from.
    /// - returns: An array of WeightedEdges containing the minimum spanning tree, or nil if the starting node is invalid. If there are is only one node connected to the starting node, an empty list is returned.
    public func mst(start: Int = 0) -> [E]? {
        if start > (nodeCount - 1) || start < 0 { return nil }

        var result: [E] = .init() // the final MST goes in here
        var queue: PriorityQueue<E> = PriorityQueue<E>(ascending: true) // minPQ
        var visited: [Bool] = .init(repeating: false, count: nodeCount) // already been to these

        func visit(_ index: Int) {
            visited[index] = true // mark as visited
            for edge in edges(for: index) where !visited[edge.v] { // add all edges coming from here to pq
                queue.push(edge)
            }
        }

        visit(start) // the first node is where everything begins

        while let edge = queue.pop() { // keep going as long as there are edges to process
            if visited[edge.v] { continue } // if we've been both places, ignore
            result.append(edge) // otherwise this is the current smallest so add it to the result set
            visit(edge.v)
        }

        return result
    }
}

// MARK: Minimum-Spanning Tree Utilities

extension WeightedGraph {
    /// Pretty print an edge list returned from an MST.
    /// - parameter edges: The edges from a previously computed MST (on this graph).
    internal func printmst(_ edges: [E]) {
        edges.forEach { print("\(node(at: $0.u)) \($0.weight)> \(node(at: $0.v))") }
        if let weight = weight(of: edges) { print("Total Weight: \(weight)") }
    }

    /// Find the total weight of the given edges.
    internal func weight(of edges: [E]) -> W? {
        guard let firstWeight = edges.first?.weight else { return nil }
        return edges.dropFirst().reduce(firstWeight) { $0 + $1.weight }
    }
}
