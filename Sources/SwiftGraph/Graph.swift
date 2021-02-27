//
//  Graph.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2019 David Kopec
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

/// The protocol for all graphs.
/// You should generally use one of its two canonical class implementations,
/// *UnweightedGraph* and *WeightedGraph*
public protocol Graph: CustomStringConvertible, Collection {
    associatedtype V: Equatable
    associatedtype E: Edge & Equatable
    var vertices: [V] { get set }
    var edges: [[E]] { get set }

    init(vertices: [V])
    func addEdge(_ e: E, directed: Bool)
}

extension Graph {
    /// How many vertices are in the graph?
    public var vertexCount: Int {
        return vertices.count
    }
    
    /// How many edges are in the graph?
    public var edgeCount: Int {
        return edges.joined().count
    }

    /// Returns a list of all the edges, undirected edges are only appended once.
    public func edgeList() -> [E] {
        let edges = self.edges
        var edgeList = [E]()
        for i in edges.indices {
            let edgesForVertex = edges[i]
            for j in edgesForVertex.indices {
                let edge = edgesForVertex[j]
                // We only want to append undirected edges once, so we do it when we find it on the
                // vertex with lowest index.
                if edge.directed || edge.v >= edge.u {
                    edgeList.append(edge)
                }
            }
        }
        return edgeList
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
        if let i = vertices.firstIndex(of: vertex) {
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
    public func edgesForIndex(_ index: Int) -> [E] {
        return edges[index]
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// - parameter vertex: The vertex to find the edges of.
    public func edgesForVertex(_ vertex: V) -> [E]? {
        if let i = indexOfVertex(vertex) {
            return edgesForIndex(i)
        }
        return nil
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
    public mutating func addVertex(_ v: V) -> Int {
        vertices.append(v)
        edges.append([E]())
        return vertices.count - 1
    }

    /// Add an edge to the graph.
    ///
    /// - parameter e: The edge to add.
    /// - parameter directed: If false, undirected edges are created.
    ///                       If true, a reversed edge is also created.
    ///                       Default is false.
    public mutating func addEdge(_ e: E, directed: Bool = false) {
        edges[e.u].append(e)
        if !directed && e.u != e.v {
            edges[e.v].append(e.reversed())
        }
    }
    
    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func removeAllEdges(from: Int, to: Int, bidirectional: Bool = true) {
        edges[from].removeAll(where: { $0.v == to })
        
        if bidirectional {
            edges[to].removeAll(where: { $0.v == from })
        }
    }
    
    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func removeAllEdges(from: V, to: V, bidirectional: Bool = true) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                removeAllEdges(from: u, to: v, bidirectional: bidirectional)
            }
        }
    }
    
    /// Remove the first edge found to be equal to *e*
    ///
    /// - parameter e: The edge to remove.
    public mutating func removeEdge(_ e: E) {
        if let index = edges[e.u].firstIndex(where: { $0 == e }) {
            edges[e.u].remove(at: index)
        }
    }
    
    /// Removes a vertex at a specified index, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public mutating func removeVertexAtIndex(_ index: Int) {
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
            for f in toRemove.reversed() {
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
            for f in toRemove.reversed() {
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
    public mutating func removeVertex(_ vertex: V) {
        if let i = indexOfVertex(vertex) {
            removeVertexAtIndex(i)
        }
    }

    /// Check whether an edge is in the graph or not.
    ///
    /// - parameter edge: The edge to find in the graph.
    /// - returns: True if the edge exists, and false otherwise.
    public func edgeExists(_ edge: E) -> Bool {
        return edges[edge.u].contains(edge)
    }
    
    // MARK: Implement Printable protocol
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
    
    // MARK: Implement CollectionType
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return vertexCount
    }
    
    public func index(after i: Int) -> Int {
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

