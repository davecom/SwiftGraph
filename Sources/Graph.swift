//
//  Graph.swift
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

/// The superclass for all graphs. Defined as a class instead of a protocol so that its subclasses can
/// have some method implementations in common. You should generally use one of its two canonical subclasses,
/// *UnweightedGraph* and *WeightedGraph*, because they offer more functionality and convenience.
open class Graph<V: Equatable>: CustomStringConvertible, Sequence, Collection {
    var vertices: [V] = [V]()
    var edges: [[Edge]] = [[Edge]]() //adjacency lists
    
    /// How many vertices are in the graph?
    public var vertexCount: Int {
        return vertices.count
    }
    
    /// How many edges are in the graph?
    public var edgeCount: Int {
        return edges.joined().count
    }
    
    /// An immutable array containing all of the vertices in the graph.
    public var immutableVertices: [V] {
        return vertices
    }
    
    public init() {
    }
    
    public init(vertices: [V]) {
        for vertex in vertices {
            _ = addVertex(vertex)
        }
    }
    
    /// Get a vertex by its index.
    ///
    /// - parameter index: The index of the vertex.
    /// - returns: The vertex at i.
    public func vertexAtIndex(_ index: Int) -> V {
        return vertices[index]
    }
    
    /// Find the first occurence of a vertex if it exists.
    ///
    /// - parameter vertex: The vertex you are looking for.
    /// - returns: The index of the vertex. Return nil if it can't find it.
    
    public func indexOfVertex(_ vertex: V) -> Int? {
        if let i = vertices.index(of: vertex) {
            return i
        }
        return nil;
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of the neighbor vertices.
    public func neighborsForIndex(_ index: Int) -> [V] {
        return edges[index].map({self.vertices[$0.v]})
    }
    
    /// Find all of the neighbors of a given Vertex.
    ///
    /// - parameter vertex: The vertex to find the neighbors of.
    /// - returns: An optional array of the neighbor vertices.
    public func neighborsForVertex(_ vertex: V) -> [V]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    /// Find all of the edges of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the children of.
    public func edgesForIndex(_ index: Int) -> [Edge] {
        return edges[index]
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// - parameter vertex: The vertex to find the edges of.
    public func edgesForVertex(_ vertex: V) -> [Edge]? {
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
                return edgeExists(from: u, to: v)
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
    public func addVertex(_ v: V) -> Int {
        vertices.append(v)
        edges.append([Edge]())
        return vertices.count - 1
    }
    
    /// Add an edge to the graph. It should take
    ///
    /// - parameter e: The edge to add.
    public func addEdge(_ e: Edge) {
        edges[e.u].append(e)
        if !e.directed {
            edges[e.v].append(e.reversed)
        }
    }
    
    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func removeAllEdges(from: Int, to: Int, bidirectional: Bool = true) {
        for i in 0..<edges[from].count where edges[from][i].v == to {
            edges[from].remove(at: i)
        }
        
        if bidirectional {
            for i in 0..<edges[to].count where edges[to][i].v == from {
                edges[to].remove(at: i)
            }
        }
    }
    
    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func removeAllEdges(from: V, to: V, bidirectional: Bool = true) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                removeAllEdges(from: u, to: v, bidirectional: bidirectional)
            }
        }
    }
    
    /// Removes a vertex at a specified index, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public func removeVertexAtIndex(_ index: Int) {
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
                edges[j].remove(at: f)
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
                edges[j].remove(at: f)
            }
        }
        //println(self)
        //remove the actual vertex and its edges
        edges.remove(at: index)
        vertices.remove(at: index)
    }
    
    /// Removes the first occurence of a vertex, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter vertex: The vertex to be removed..
    public func removeVertex(_ vertex: V) {
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
    public typealias Iterator = AnyIterator<V>
    
    public func makeIterator() -> Iterator {
        var index = 0
        return AnyIterator {
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
    
    public func index(after i: Graph.Index) -> Graph.Index {
        return i + 1
    }
    
    /// The same as vertexAtIndex() - returns the vertex at index
    ///
    ///
    /// - Parameter index: The index of vertex to return.
    /// - returns: The vertex at index.
    public subscript(i: Int) -> V {
        return vertexAtIndex(i)
    }
}
