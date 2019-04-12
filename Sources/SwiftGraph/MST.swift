//
//  MST.swift
//  SwiftGraph
//
//  Copyright (c) 2017-2019 David Kopec
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

/// Extensions to WeightedGraph for building a Minimum-Spanning Tree (MST)

public extension WeightedGraph where W: Comparable {
    
    // Citation: Based on Algorithms 4th Edition by Sedgewick, Wayne pg 619
    
    /// Find the minimum spanning tree in a weighted graph. This is the set of edges
    /// that touches every vertex in the graph and is of minimal combined weight. This function
    /// uses Jarnik's Algorithm (aka Prim's Algorithm) and so assumes the graph has
    /// undirected edges. For a graph with directed edges, the result may be incorrect. Also,
    /// if the graph is not fully connected, the tree will only span the connected component from which
    /// the starting vertex belongs.
    ///
    /// - parameter start: The index of the vertex to start creating the MST from.
    /// - returns: An array of WeightedEdges containing the minimum spanning tree, or nil if the starting vertex is invalid. If there are is only one vertex connected to the starting vertex, an empty list is returned.
    func mst(start: Int = 0) -> [WeightedEdge<W>]? {
        if start > (vertexCount - 1) || start < 0 { return nil }
        var result: [WeightedEdge<W>] = [WeightedEdge<W>]() // the final MST goes in here
        var pq: PriorityQueue<WeightedEdge<W>> = PriorityQueue<WeightedEdge<W>>(ascending: true) // minPQ
        var visited: [Bool] = Array<Bool>(repeating: false, count: vertexCount) // already been to these
        
        func visit(_ index: Int) {
            visited[index] = true // mark as visited
            for edge in edgesForIndex(index) { // add all edges coming from here to pq
                if !visited[edge.v] { pq.push(edge) }
            }
        }
        
        visit(start) // the first vertex is where everything begins
        
        while let edge = pq.pop() { // keep going as long as there are edges to process
            if visited[edge.v] { continue } // if we've been both places, ignore
            result.append(edge) // otherwise this is the current smallest so add it to the result set
            visit(edge.v)
        }
        
        return result
    }
}

/// Find the total weight of a list of weighted edges
/// - parameter edges The edge array to find the total weight of.
public func totalWeight<W: Numeric>(_ edges: [WeightedEdge<W>]) -> W? {
    guard let firstWeight = edges.first?.weight else { return nil }
    return edges.dropFirst().reduce(firstWeight) { (result, next) -> W in
        return result + next.weight
    }
}

/// Pretty print an edge list returned from an MST
/// - parameter edges The edge array representing the MST
public func printMST<V, W: Numeric>(edges: [WeightedEdge<W>], graph: WeightedGraph<V, W>) {
    for edge in edges {
        print("\(graph.vertexAtIndex(edge.u)) \(edge.weight)> \(graph.vertexAtIndex(edge.v))")
    }
    if let tw = totalWeight(edges) {
        print("Total Weight: \(tw)")
    }
}
