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
open class WeightedGraph<T: Equatable, W: Comparable & Summable>: Graph<T> {
    public override init() {
        super.init()
    }
    
    public override init(vertices: [T]) {
        super.init(vertices: vertices)
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of tuples including the vertices as the first element and the weights as the second element.
    public func neighborsForIndexWithWeights(_ index: Int) -> [(T, W)] {
        var distanceTuples: [(T, W)] = [(T, W)]();
        for edge in edges[index] {
            if let edge = edge as? WeightedEdge<W> {
                distanceTuples += [(vertices[edge.v], edge.weight)]
            }
        }
        return distanceTuples;
    }
    
    /// Add an edge to the graph. It must be weighted or the call will be ignored.
    ///
    /// - parameter edge: The edge to add.
    public override func addEdge(_ edge: Edge) {
        guard edge.weighted else {
            print("Error: Tried adding non-weighted Edge to WeightedGraph. Ignoring call.")
            return
        }
        super.addEdge(edge)
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: Int, to: Int, directed: Bool = false, weight:W) {
        addEdge(WeightedEdge<W>(u: from, v: to, directed: directed, weight: weight))
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: T, to: T, directed: Bool = false, weight: W) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(WeightedEdge<W>(u: u, v: v, directed: directed, weight:weight))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific weighted edge in both directions (if it's not directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public func removeEdge(_ edge: WeightedEdge<W>) {
        if let i = (edges[edge.u] as! [WeightedEdge<W>]).index(of: edge) {
            edges[edge.u].remove(at: i)
            if !edge.directed {
                if let i = (edges[edge.v] as! [WeightedEdge<W>]).index(of: edge.reversed as! WeightedEdge) {
                    edges[edge.v].remove(at: i)
                }
            }
        }
    }
    
    //Implement Printable protocol
    public override var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))\n"
        }
        return d
    }
}

