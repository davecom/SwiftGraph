//
//  WeightedGraph.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2015 David Kopec
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

/// A subclass of Graph that has convenience methods for adding and removing WeightedEdges. All added Edges should have the same generic Comparable type W as the WeightedGraph itself.
public class WeightedGraph<T: Equatable, W: protocol<Comparable, Summable>>: Graph<T> {
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
    public func neighborsForIndexWithWeights(index: Int) -> [(T, W)] {
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
    public override func addEdge(edge: Edge) {
        if !edge.weighted {
            print("Error: Tried adding non-weighted Edge to WeightedGraph. Ignoring call.")
            return
        }
        super.addEdge(edge)
    }
    
    /// This is a convenience method that adds a weighted, undirected edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter weight: The weight of the edge to be added.
    public func addEdge(from: Int, to: Int, weight:W) {
        addEdge(WeightedEdge<W>(u: from, v: to, directed: false, weight:weight))
    }
    
    /// This is a convenience method that adds a weighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter weight:
    public func addEdge(from: T, to: T, weight:W) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(WeightedEdge<W>(u: u, v: v, directed: false, weight: weight))
            }
        }
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed?
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: Int, to: Int, directed: Bool, weight:W) {
        addEdge(WeightedEdge<W>(u: from, v: to, directed: directed, weight: weight))
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed?
    public func addEdge(from: T, to: T, directed: Bool, weight: W) {
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
    public func removeEdge(edge: WeightedEdge<W>) {
        if let i = (edges[edge.u] as! [WeightedEdge<W>]).indexOf(edge) {
            edges[edge.u].removeAtIndex(i)
            if !edge.directed {
                if let i = (edges[edge.v] as! [WeightedEdge<W>]).indexOf(edge.reversed as! WeightedEdge) {
                    edges[edge.v].removeAtIndex(i)
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

