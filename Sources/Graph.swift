//
//  Graph.swift
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

/// The superclass for all graphs. Defined as a class instead of a protocol so that its subclasses can
/// have some method implementations in common. You should generally use one of its two canonical subclasses,
/// *UnweightedGraph* and *WeightedGraph*, because they offer more functionality and convenience.
public class Graph<V: Equatable>: CustomStringConvertible, SequenceType, CollectionType {
    var vertices: [V] = [V]()
    var edges: [[Edge]] = [[Edge]]() //adjacency lists
    
    /// How many vertices are in the graph?
    public var vertexCount: Int {
        return vertices.count
    }
    
    /// An immutable array containing all of the vertices in the graph.
    public var immutableVertices: [V] {
        return vertices
    }
    
    public init() {
    }
    
    public init(vertices: [V]) {
        for vertex in vertices {
            addVertex(vertex)
        }
    }
    
    /// Get a vertex by its index.
    ///
    /// - parameter index: The index of the vertex.
    /// - returns: The vertex at i.
    public func vertexAtIndex(index: Int) -> V {
        return vertices[index]
    }
    
    /// Find the first occurence of a vertex if it exists.
    ///
    /// - parameter vertex: The vertex you are looking for.
    /// - returns: The index of the vertex. Return nil if it can't find it.
    
    public func indexOfVertex(vertex: V) -> Int? {
        if let i = vertices.indexOf(vertex) {
            return i
        }
        return nil;
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of the neighbor vertices.
    public func neighborsForIndex(index: Int) -> [V] {
        return edges[index].map({self.vertices[$0.v]})
    }
    
    /// Find all of the neighbors of a given Vertex.
    ///
    /// - parameter vertex: The vertex to find the neighbors of.
    /// - returns: An optional array of the neighbor vertices.
    public func neighborsForVertex(vertex: V) -> [V]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    /// Find all of the edges of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the children of.
    public func edgesForIndex(index: Int) -> [Edge] {
        return edges[index]
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// - parameter vertex: The vertex to find the edges of.
    public func edgesForVertex(vertex: V) -> [Edge]? {
        if let i = indexOfVertex(vertex) {
            return edgesForIndex(i)
        }
        return nil
    }
    
    /// Is there an edge from one vertex to another?
    ///
    /// - parameter from: The index of the starting edge.
    /// - parameter to: The index of the ending edge.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edgeExists(from: Int, to: Int) -> Bool {
        return edges[from].map({$0.v}).contains(to)
    }
    
    /// Is there an edge from one vertex to another? Note this will look at the first occurence of each vertex. Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The first vertex.
    /// - parameter to: The second vertex.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edgeExists(from: V, to: V) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(u, to: v)
            }
        }
        return false
    }
    
    /// Find the first occurence of a vertex.
    ///
    /// - parameter vertex: The vertex you are looking for.
    public func vertexInGraph(vertex: V) -> Bool {
        if let _ = indexOfVertex(vertex) {
            return true
        }
        return false
    }
    
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added.
    public func addVertex(v: V) -> Int {
        vertices.append(v)
        edges.append([Edge]())
        return vertices.count - 1
    }
    
    /// Add an edge to the graph. It should take
    ///
    /// - parameter e: The edge to add.
    public func addEdge(e: Edge) {
        edges[e.u].append(e)
        if !e.directed {
            edges[e.v].append(e.reversed)
        }
    }
    
    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    public func removeAllEdges(from: Int, to: Int) {
        for i in 0..<edges[from].count {
            if edges[from][i].v == from {
                edges[from].removeAtIndex(i)
            }
        }
        
        for i in 0..<edges[from].count {
            if edges[from][i].v == to {
                edges[from].removeAtIndex(i)
            }
        }
    }
    
    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    public func removeAllEdges(from: V, to: V) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                for i in 0..<edges[u].count {
                    if edges[u][i].v == v {
                        edges[u].removeAtIndex(i)
                    }
                }
                
                for i in 0..<edges[v].count {
                    if edges[v][i].v == u {
                        edges[v].removeAtIndex(i)
                    }
                }
            }
        }
    }
    
    /// Removes a vertex at a specified index, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public func removeVertexAtIndex(index: Int) {
        //remove all edges ending at the vertex, first doing the ones below it
        //renumber edges that end after the index
        for j in 0..<index {
            var toRemove: [Int] = [Int]()
            for l in 0..<edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                if edges[j][l].v > index {
                    edges[j][l].v -= 1
                }
            }
            for f in toRemove {
                edges[j].removeAtIndex(f)
            }
        }
        
        //remove all edges after the vertex index wise
        //renumber all edges after the vertex index wise
        for j in (index + 1)..<edges.count {
            var toRemove: [Int] = [Int]()
            for l in 0..<edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                edges[j][l].u -= 1
                if edges[j][l].v > index {
                    edges[j][l].v -= 1
                }
            }
            for f in toRemove {
                edges[j].removeAtIndex(f)
            }
        }
        //println(self)
        //remove the actual vertex and its edges
        edges.removeAtIndex(index)
        vertices.removeAtIndex(index)
    }
    
    /// Removes the first occurence of a vertex, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter vertex: The vertex to be removed..
    public func removeVertex(vertex: V) {
        if let i = indexOfVertex(vertex) {
            removeVertexAtIndex(i)
        }
    }
    
    //Implement Printable protocol
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
    
    //Implement SequenceType
    public typealias Generator = AnyGenerator<V>
    
    public func generate() -> Generator {
        var index = 0
        return AnyGenerator {
            if index < self.vertices.count {
                index += 1
                return self.vertexAtIndex(index - 1)
            }
            return nil
        }
    }
    
    //Implement CollectionType
    public typealias Index = Int
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return vertexCount
    }
    
    public subscript(i: Int) -> V {
        return vertexAtIndex(i)
    }
}
