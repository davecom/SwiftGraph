//
//  UnweightedGraph.swift
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

/// A subclass of Graph with some convenience methods for adding and removing UnweightedEdges. WeightedEdges may be added to an UnweightedGraph but their weights will be ignored.
public class UnweightedGraph<T: Equatable>: Graph<T> {
    public override init() {
        super.init()
    }
    
    public override init(vertices: [T]) {
        super.init(vertices: vertices)
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    public func addEdge(from: Int, to: Int) {
        addEdge(UnweightedEdge(u: from, v: to, directed: false))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    public func addEdge(from: T, to: T) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: false))
            }
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed?
    public func addEdge(from: Int, to: Int, directed: Bool) {
        addEdge(UnweightedEdge(u: from, v: to, directed: directed))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed?
    public func addEdge(from: T, to: T, directed: Bool) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: directed))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific unweighted edge in both directions (if it's not directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public func removeEdge(edge: UnweightedEdge) {
        if let i = (edges[edge.u] as! [UnweightedEdge]).indexOf(edge) {
            edges[edge.u].removeAtIndex(i)
            if !edge.directed {
                if let i = (edges[edge.v] as! [UnweightedEdge]).indexOf(edge.reversed as! UnweightedEdge) {
                    edges[edge.v].removeAtIndex(i)
                }
            }
        }
    }
}

