//
//  SwiftGraph.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

/// A protocol that all edges in a graph must conform to.
protocol Edge {
    var u: Int {get set}  //made modifiable for changing when removing vertices
    var v: Int {get set}  //made modifiable for changing when removing vertices
    var weighted: Bool {get}
    var directed: Bool {get}
    var reversed: Edge {get}
}

/// A basic unweighted edge.
class UnweightedEdge: Edge, Equatable {
    var u: Int
    var v: Int
    var weighted: Bool { return false }
    let directed: Bool
    var reversed:Edge {
        return UnweightedEdge(u: v, v: u, directed: directed)
    }
    
    init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }
}

func ==(lhs: UnweightedEdge, rhs: UnweightedEdge) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed
}

/// A weighted edge, who's weight subscribes to Comparable.
class WeightedEdge<W: Comparable>: UnweightedEdge, Equatable {
    override var weighted: Bool { return true }
    let weight: W
    override var reversed:Edge {
        return WeightedEdge(u: v, v: u, directed: directed, weight: weight)
    }
    
    init(u: Int, v: Int, directed: Bool, weight: W) {
        self.weight = weight
        super.init(u: u, v: v, directed: directed)
    }
}

func ==<W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
}

/// The superclass for all graphs. Defined as a class instead of a protocol so that its subclasses can
/// have some method implementations in common. You should generally use one of its two canonical subclasses,
/// *UnweightedGraph* and *WeightedGraph*, because they offer more functionality and convenience.
class Graph<V: Equatable>: Printable {
    private var vertices: [V] = [V]()
    private var edges: [[Edge]] = [[Edge]]() //adjacency lists
    
    /// How many vertices are in the graph?
    var vertexCount: Int {
        return vertices.count
    }
    
    /// An immutable array containing all of the vertices in the graph.
    var immutableVertices: [V] {
        return vertices
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
    /// :param: index The index of the vertex.
    /// :returns: The vertex at i.
    func getVertex(index: Int) -> V {
        return vertices[index]
    }
    
    /// Find the first occurence of a vertex if it exists.
    ///
    /// :param: vertex The vertex you are looking for.
    /// :returns: The index of the vertex. Return nil if it can't find it.
    
    func indexOfVertex(vertex: V) -> Int? {
        if let i = find(vertices, vertex) {
            return i
        }
        return nil;
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// :param: index The index for the vertex to find the neighbors of.
    /// :returns: An array of the neighbor vertices.
    func neighborsForIndex(index: Int) -> [V] {
        return edges[index].map({self.vertices[$0.v]})
    }
    
    /// Find all of the neighbors of a given Vertex.
    ///
    /// :param: vertex The vertex to find the neighbors of.
    /// :returns: An optional array of the neighbor vertices.
    func neighborsForVertex(vertex: V) -> [V]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    /// Find all of the edges of a vertex at a given index.
    ///
    /// :param: index The index for the vertex to find the children of.
    func edgesForIndex(index: Int) -> [Edge] {
        return edges[index]
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// :param: vertex The vertex to find the edges of.
    func edgesForVertex(vertex: V) -> [Edge]? {
        if let i = indexOfVertex(vertex) {
            return edgesForIndex(i)
        }
        return nil
    }
    
    /// Is there an edge from one vertex to another?
    ///
    /// :param: from The index of the starting edge.
    /// :param: to The index of the ending edge.
    /// :returns: A Bool that is true if such an edge exists, and false otherwise.
    func edgeExists(from: Int, to: Int) -> Bool {
        return contains(edges[from].map({$0.v}), to)
    }
    
    /// Is there an edge from one vertex to another? Note this will look at the first occurence of each vertex. Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// :param: from The first vertex.
    /// :param: to The second vertex.
    /// :returns: A Bool that is true if such an edge exists, and false otherwise.
    func edgeExists(from: V, to: V) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(u, to: v)
            }
        }
        return false
    }
    
    /// Find the first occurence of a vertex.
    ///
    /// :param: vertex The vertex you are looking for.
    func vertexInGraph(vertex: V) -> Bool {
        if let i = indexOfVertex(vertex) {
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
    
    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// :param: from The starting vertex's index.
    /// :param: to The ending vertex's index.
    func removeAllEdges(from: Int, to: Int) {
        for var i = 0; i < edges[from].count; i++ {
            if edges[from][i].v == from {
                edges[from].removeAtIndex(i)
            }
        }
        
        for var i = 0; i < edges[from].count; i++ {
            if edges[from][i].v == to {
                edges[from].removeAtIndex(i)
            }
        }
    }
    
    /// Removes all edges in both directions between two vertices.
    ///
    /// :param: from The starting vertex.
    /// :param: to The ending vertex.
    func removeAllEdges(from: V, to: V) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
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
    /// :param: index The index of the vertex.
    func removeVertexAtIndex(index: Int) {
        //remove all edges ending at the vertex, first doing the ones below it
        //renumber edges that end after the index
        for var j = 0; j < index; j++ {
            var toRemove: [Int] = [Int]()
            for var l = 0; l < edges[j].count; l++ {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                if edges[j][l].v > index {
                    edges[j][l].v--
                }
            }
            for f in toRemove {
                edges[j].removeAtIndex(f)
            }
        }
        
        //remove all edges after the vertex index wise
        //renumber all edges after the vertex index wise
        for var j = (index + 1); j < edges.count; j++ {
            var toRemove: [Int] = [Int]()
            for var l = 0; l < edges[j].count; l++ {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                edges[j][l].u--
                if edges[j][l].v > index {
                    edges[j][l].v--
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
    /// :param: vertex The vertex to be removed..
    func removeVertex(vertex: V) {
        if let i = indexOfVertex(vertex) {
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

/// A subclass of Graph with some convenience methods for adding and removing UnweightedEdges. WeightedEdges may be added to an UnweightedGraph but their weights will be ignored.
class UnweightedGraph<T: Equatable>: Graph<T> {
    override init() {
        super.init()
    }
    
    override init(vertices: [T]) {
        super.init(vertices: vertices)
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge.
    ///
    /// :param: from The starting vertex's index.
    /// :param: to The ending vertex's index.
    func addEdge(from: Int, to: Int) {
        addEdge(UnweightedEdge(u: from, v: to, directed: false))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: from The starting vertex.
    /// :param: to The ending vertex.
    func addEdge(from: T, to: T) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: false))
            }
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// :param: from The starting vertex's index.
    /// :param: to The ending vertex's index.
    /// :param: directed Is the edge directed?
    func addEdge(from: Int, to: Int, directed: Bool) {
        addEdge(UnweightedEdge(u: from, v: to, directed: directed))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: from The starting vertex.
    /// :param: to The ending vertex.
    /// :param: directed Is the edge directed?
    func addEdge(from: T, to: T, directed: Bool) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: directed))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific unweighted edge in both directions (if it's not directional). Or just one way if it's directed.
    ///
    /// :param: edge The edge to be removed.
    func removeEdge(edge: UnweightedEdge) {
        if let i = find(edges[edge.u] as [UnweightedEdge], edge) {
            edges[edge.u].removeAtIndex(i)
            if !edge.directed {
                if let i = find(edges[edge.v] as [UnweightedEdge], edge.reversed as UnweightedEdge) {
                    edges[edge.v].removeAtIndex(i)
                }
            }
        }
    }
}

/// A subclass of Graph that has convenience methods for adding and removing WeightedEdges. All added Edges should have the same generic Comparable type W as the WeightedGraph itself.
class WeightedGraph<T: Equatable, W: Comparable>: Graph<T> {
    override init() {
        super.init()
    }
    
    override init(vertices: [T]) {
        super.init(vertices: vertices)
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// :param: index The index for the vertex to find the neighbors of.
    /// :returns: An array of tuples including the vertices as the first element and the weights as the second element.
    func neighborsForIndexWithWeights(index: Int) -> [(T, W)] {
        var distanceTuples: [(T, W)] = [(T, W)]();
        for edge in edges[index] {
            if let edge = edge as? WeightedEdge<W> {
                distanceTuples += [(vertices[edge.v], edge.weight)]
            }
        }
        return distanceTuples;
        //if let edges = edges[index] as? [WeightedEdge<W>] {
        //    return edges.map({(self.vertices[$0.v], $0.weight)})
        //}
        //return []
    }
    
    /// Add an edge to the graph. It must be weighted or the call will be ignored.
    ///
    /// :param: edge The edge to add.
    override func addEdge(edge: Edge) {
        if !edge.weighted {
            println("Error: Tried adding non-weighted Edge to WeightedGraph. Ignoring call.")
            return
        }
        super.addEdge(edge)
    }
    
    /// This is a convenience method that adds a weighted, undirected edge.
    ///
    /// :param: from The starting vertex's index.
    /// :param: to The ending vertex's index.
    /// :param: weight The weight of the edge to be added.
    func addEdge(from: Int, to: Int, weight:W) {
        addEdge(WeightedEdge<W>(u: from, v: to, directed: false, weight:weight))
    }
    
    /// This is a convenience method that adds a weighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: from The starting vertex.
    /// :param: to The ending vertex.
    /// :param: weight
    func addEdge(from: T, to: T, weight:W) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(WeightedEdge<W>(u: u, v: v, directed: false, weight: weight))
            }
        }
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// :param: from The starting vertex's index.
    /// :param: to The ending vertex's index.
    /// :param: directed Is the edge directed?
    /// :param: weight the Weight of the edge to add.
    func addEdge(from: Int, to: Int, directed: Bool, weight:W) {
        addEdge(WeightedEdge<W>(u: from, v: to, directed: directed, weight: weight))
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// :param: from The starting vertex.
    /// :param: to The ending vertex.
    /// :param: directed Is the edge directed?
    func addEdge(from: T, to: T, directed: Bool, weight: W) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(WeightedEdge<W>(u: u, v: v, directed: directed, weight:weight))
            }
        }
    }
    
    //Have to have two of these because Edge protocol cannot adopt Equatable
    
    /// Removes a specific weighted edge in both directions (if it's not directional). Or just one way if it's directed.
    ///
    /// :param: edge The edge to be removed.
    func removeEdge(edge: WeightedEdge<W>) {
        if let i = find(edges[edge.u] as [WeightedEdge<W>], edge) {
            edges[edge.u].removeAtIndex(i)
            if !edge.directed {
                if let i = find(edges[edge.v] as [WeightedEdge<W>], edge.reversed as WeightedEdge) {
                    edges[edge.v].removeAtIndex(i)
                }
            }
        }
    }
    
    //Implement Printable protocol
    override var description: String {
        var d: String = ""
        for var i = 0; i < vertices.count; i++ {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))\n"
        }
        return d
    }
}