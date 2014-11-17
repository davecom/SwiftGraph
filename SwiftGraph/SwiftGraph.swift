//
//  SwiftGraph.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

protocol Edge {
    var u: Int {get set}  //made modifiable for changing when removing vertices
    var v: Int {get set}  //made modifiable for changing when removing vertices
    var weighted: Bool {get}
    var directed: Bool {get}
    var reversed: Edge {get}
}

struct UnweightedEdge: Edge, Equatable {
    var u: Int
    var v: Int
    let weighted: Bool = false
    let directed: Bool
    var reversed:Edge {
        return UnweightedEdge(u: v, v: u, weighted: weighted, directed: directed)
    }
}

func ==(lhs: UnweightedEdge, rhs: UnweightedEdge) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed
}

struct WeightedEdge<W: Comparable>: Edge, Equatable {
    var u: Int
    var v: Int
    let weighted: Bool = true
    let directed: Bool
    let weight: W
    var reversed:Edge {
        return WeightedEdge(u: v, v: u, weighted: weighted, directed: directed, weight: weight)
    }
}

func ==<W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
}

class Graph<V: Equatable>: Printable {
    private var vertices: [V] = [V]()
    private var edges: [[Edge]] = [[Edge]]() //adjacency lists
    var vCount: Int {
        return vertices.count
    }
    
    init() {
    }
    
    init(vertices: [V]) {
        for vertex in vertices {
            addVertex(vertex)
        }
    }
    
    /// Get a vertex by its index.
    ///
    /// :param: i The index of the vertex.
    func getVertex(i: Int) -> V {
        return vertices[i]
    }
    
    /// Find the first occurence of a vertex if it exists and returns its index. Return nil if it can't find it.
    ///
    /// :param: v The vertex you are looking for.
    func indexOfVertex(v: V) -> Int? {
        if let i = find(vertices, v) {
            return i
        }
        return nil;
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// :param: i The index for the vertex to find the neighbors of.
    func neighborsForIndex(i: Int) -> [V] {
        return edges[i].map({self.vertices[$0.v]})
    }
    
    /// Find all of the neighbors of a given Vertex.
    ///
    /// :param: v The vertex to find the neighbors of.
    func neighborsForVertex(v: V) -> [V]? {
        if let i = indexOfVertex(v) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    /// Find all of the edges of a vertex at a given index.
    ///
    /// :param: i The index for the vertex to find the children of.
    func edgesForIndex(i: Int) -> [Edge] {
        return edges[i]
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// :param: v The vertex to find the edges of.
    func edgesForVertex(v: V) -> [Edge]? {
        if let i = indexOfVertex(v) {
            return edgesForIndex(i)
        }
        return nil
    }
    
    /// Find the first occurence of a vertex.
    ///
    /// :param: v The vertex you are looking for.
    func vertexInGraph(v: V) -> Bool {
        if let i = indexOfVertex(v) {
            return true
        }
        return false
    }
    
    /// Add a vertex to the graph.
    ///
    /// :param: v The vertex to be added.
    func addVertex(v: V) {
        vertices.append(v)
        edges.append([Edge]())
    }
    
    /// Add an edge to the graph. It should take
    ///
    /// :param: e The edge to add.
    func addEdge(e: Edge) {
        edges[e.u].append(e)
        if !e.directed {
            edges[e.v].append(e.reversed)
        }
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge.
    ///
    /// :param: u The starting vertex's index.
    /// :param: v The ending vertex's index.
    func addEdge(u: Int, v: Int) {
        addEdge(UnweightedEdge(u: u, v: v, weighted: false, directed: false))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: u The starting vertex.
    /// :param: v The ending vertex.
    func addEdge(u: V, v: V) {
        if let u = indexOfVertex(u) {
            if let v = indexOfVertex(v) {
                addEdge(UnweightedEdge(u: u, v: v, weighted: false, directed: false))
            }
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// :param: u The starting vertex's index.
    /// :param: v The ending vertex's index.
    /// :param: directed Is the edge directed?
    func addEdge(u: Int, v: Int, directed: Bool) {
        addEdge(UnweightedEdge(u: u, v: v, weighted: false, directed: directed))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: u The starting vertex.
    /// :param: v The ending vertex.
    /// :param: directed Is the edge directed?
    func addEdge(u: V, v: V, directed: Bool) {
        if let u = indexOfVertex(u) {
            if let v = indexOfVertex(v) {
                addEdge(UnweightedEdge(u: u, v: v, weighted: false, directed: directed))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific unweighted edge in both directions (if it's directional). Or just one way if it's not.
    ///
    /// :param: e The edge to be removed.
    func removeEdge(e: UnweightedEdge) {
        if let i = find(edges[e.u] as [UnweightedEdge], e) {
            edges[e.u].removeAtIndex(i)
            if e.directed {
                if let i = find(edges[e.v] as [UnweightedEdge], e) {
                    edges[e.v].removeAtIndex(i)
                }
            }
        }
    }
    
    /// Removes all edges in both directions between vertices at indexes u and v.
    ///
    /// :param: u The starting vertex's index.
    /// :param: v The ending vertex's index.
    func removeAllEdges(u: Int, v: Int) {
        for var i = 0; i < edges[u].count; i++ {
            if edges[u][i].v == v {
                edges[u].removeAtIndex(i)
            }
        }
        
        for var i = 0; i < edges[v].count; i++ {
            if edges[v][i].v == u {
                edges[v].removeAtIndex(i)
            }
        }
    }
    
    /// Removes all edges in both directions between vertices u and v.
    ///
    /// :param: u The starting vertex.
    /// :param: v The ending vertex.
    func removeAllEdges(u: V, v: V) {
        if let u = indexOfVertex(u) {
            if let v = indexOfVertex(v) {
                for var i = 0; i < edges[u].count; i++ {
                    if edges[u][i].v == v {
                        edges[u].removeAtIndex(i)
                    }
                }
                
                for var i = 0; i < edges[v].count; i++ {
                    if edges[v][i].v == u {
                        edges[v].removeAtIndex(i)
                    }
                }
            }
        }
    }
    
    /// Removes a vertex at a specified index, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// :param: i The index of the vertex.
    func removeVertexAtIndex(i: Int) {
        //remove all edges ending at the vertex, first doing the ones below it
        //renumber edges that end after the index
        for var j = 0; j < i; j++ {
            var toRemove: [Int] = [Int]()
            for var l = 0; l < edges[j].count; l++ {
                if edges[j][l].v == i {
                    toRemove.append(l)
                    continue
                }
                if edges[j][l].v > i {
                    edges[j][l].v--
                }
            }
            for f in toRemove {
                edges[j].removeAtIndex(f)
            }
        }
        
        //remove all edges after the vertex index wise
        //renumber all edges after the vertex index wise
        for var j = (i + 1); j < edges.count; j++ {
            var toRemove: [Int] = [Int]()
            for var l = 0; l < edges[j].count; l++ {
                if edges[j][l].v == i {
                    toRemove.append(l)
                    continue
                }
                edges[j][l].u--
                if edges[j][l].v > i {
                    edges[j][l].v--
                }
            }
            for f in toRemove {
                edges[j].removeAtIndex(f)
            }
        }
        println(self)
        //remove the actual vertex and its edges
        edges.removeAtIndex(i)
        vertices.removeAtIndex(i)
    }
    
    /// Removes a vertex, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// :param: i The index of the vertex.
    func removeVertex(v: V) {
        if let i = indexOfVertex(v) {
            removeVertexAtIndex(i)
        }
    }
    
    //Implement Printable protocol
    var description: String {
        var d: String = ""
        for var i = 0; i < vertices.count; i++ {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
}

class WeightedGraph<V: Equatable, W: Comparable>: Graph<V> {
    private override var edges: [[Edge]] = [[WeightedEdge<W>]]()
    
    
}