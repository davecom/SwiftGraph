//
//  SwiftGraph.swift
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

/// A protocol that all edges in a graph must conform to.
public protocol Edge: CustomStringConvertible {
    var u: Int {get set}  //made modifiable for changing when removing vertices
    var v: Int {get set}  //made modifiable for changing when removing vertices
    var weighted: Bool {get}
    var directed: Bool {get}
    var reversed: Edge {get}
}

/// A basic unweighted edge.
public class UnweightedEdge: Edge, Equatable, CustomStringConvertible {
    public var u: Int
    public var v: Int
    public var weighted: Bool { return false }
    public let directed: Bool
    public var reversed:Edge {
        return UnweightedEdge(u: v, v: u, directed: directed)
    }
    
    public init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }
    
    //Implement Printable protocol
    public var description: String {
        if directed {
            return "\(u) -> \(v)"
        }
        return "\(u) <-> \(v)"
    }
}

public func ==(lhs: UnweightedEdge, rhs: UnweightedEdge) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed
}

// This protocol is needed for Dijkstra's algorithm - we need weights in weighted graphs
// to be able to be added together
public protocol Summable {
    func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension Float: Summable {}
extension String: Summable {}

/// A weighted edge, who's weight subscribes to Comparable.
public class WeightedEdge<W: protocol<Comparable, Summable>>: UnweightedEdge {
    public override var weighted: Bool { return true }
    public let weight: W
    public override var reversed:Edge {
        return WeightedEdge(u: v, v: u, directed: directed, weight: weight)
    }
    
    public init(u: Int, v: Int, directed: Bool, weight: W) {
        self.weight = weight
        super.init(u: u, v: v, directed: directed)
    }
    
    //Implement Printable protocol
    public override var description: String {
        if directed {
            return "\(u) \(weight)> \(v)"
        }
        return "\(u) <\(weight)> \(v)"
    }
}

public func ==<W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
}

/// The superclass for all graphs. Defined as a class instead of a protocol so that its subclasses can
/// have some method implementations in common. You should generally use one of its two canonical subclasses,
/// *UnweightedGraph* and *WeightedGraph*, because they offer more functionality and convenience.
public class Graph<V: Equatable>: CustomStringConvertible, SequenceType, CollectionType {
    private var vertices: [V] = [V]()
    private var edges: [[Edge]] = [[Edge]]() //adjacency lists
    
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
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    public func removeAllEdges(from: V, to: V) {
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
    /// - parameter index: The index of the vertex.
    public func removeVertexAtIndex(index: Int) {
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
    /// - parameter vertex: The vertex to be removed..
    public func removeVertex(vertex: V) {
        if let i = indexOfVertex(vertex) {
            removeVertexAtIndex(i)
        }
    }
    
    //Implement Printable protocol
    public var description: String {
        var d: String = ""
        for var i = 0; i < vertices.count; i++ {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
    
    //Implement SequenceType
    public typealias Generator = AnyGenerator<V>
    
    public func generate() -> Generator {
        var index = 0
        return anyGenerator {
            if index < self.vertices.count {
                return self.vertexAtIndex(index++)
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
        for var i = 0; i < vertices.count; i++ {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))\n"
        }
        return d
    }
}

/// Implements a stack - helper class that uses an array internally.
public class Stack<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool { return container.isEmpty }
    public func push(thing: T) { container.append(thing) }
    public func pop() -> T { return container.removeLast() }
}

/// Implements a queue - helper class that uses an array internally.
public class Queue<T: Equatable> {
    private var container: [T] = [T]()
    public var isEmpty: Bool { return container.isEmpty }
    public var count: Int { return container.count }
    public func push(thing: T) { container.append(thing) }
    public func pop() -> T { return container.removeAtIndex(0) }
    public func contains(thing: T) -> Bool {
        if container.indexOf(thing) != nil {
            return true
        }
        return false
    }
}

public func pathDictToPath(from: Int, to: Int, pathDict:[Int:Edge]) -> [Edge] {
    if pathDict.count == 0 {
        return []
    }
    var edgePath: [Edge] = [Edge]()
    var e: Edge = pathDict[to]!
    edgePath.append(e)
    while (e.u != from) {
        e = pathDict[e.u]!
        edgePath.append(e)
    }
    return Array(edgePath.reverse())
}

// version for Dijkstra
public func pathDictToPath<W: protocol<Comparable, Summable>>(from: Int, to: Int, pathDict:[Int:WeightedEdge<W>]) -> [WeightedEdge<W>] {
    var edgePath: [WeightedEdge<W>] = [WeightedEdge<W>]()
    var e: WeightedEdge<W> = pathDict[to]!
    edgePath.append(e)
    while (e.u != from) {
        e = pathDict[e.u]!
        edgePath.append(e)
    }
    return Array(edgePath.reverse())
}

/// Find a route from one vertex to another using a depth first search.
///
/// :params: from The index of the starting vertex.
/// :params: to The index of the ending vertex.
/// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
public func dfs<T: Equatable>(from: Int, to: Int, graph: Graph<T>) -> [Edge] {
    // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
    var visited: [Bool] = [Bool](count: graph.vertexCount, repeatedValue: false)
    let stack: Stack<Int> = Stack<Int>()
    var pathDict: [Int: Edge] = [Int: Edge]()
    stack.push(from)
    var found: Bool = false
    while !stack.isEmpty {
        let v: Int = stack.pop()
        if v == to {
            found = true
            break
        }
        visited[v] = true
        for e in graph.edgesForIndex(v) {
            if !visited[e.v] {
                stack.push(e.v)
                pathDict[e.v] = e
            }
        }
    }
    // figure out route of edges based on pathDict
    if found {
        return pathDictToPath(from, to: to, pathDict: pathDict)
    }
    
    return []
}

/// Find a route from one vertex to another using a depth first search.
///
/// :params: from The starting vertex.
/// :params: to The ending vertex.
/// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
public func dfs<T: Equatable>(from: T, to: T, graph: Graph<T>) -> [Edge] {
    if let u = graph.indexOfVertex(from) {
        if let v = graph.indexOfVertex(to) {
            return dfs(u, to: v, graph: graph)
        }
    }
    return []
}

/// Find a route from one vertex to another using a breadth first search.
///
/// :params: from The index of the starting vertex.
/// :params: to The index of the ending vertex.
/// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
public func bfs<T: Equatable>(from: Int, to: Int, graph: Graph<T>) -> [Edge] {
    // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
    var visited: [Bool] = [Bool](count: graph.vertexCount, repeatedValue: false)
    let queue: Queue<Int> = Queue<Int>()
    var pathDict: [Int: Edge] = [Int: Edge]()
    queue.push(from)
    var found: Bool = false
    while !queue.isEmpty {
        let v: Int = queue.pop()
        if v == to {
            found = true
            break
        }
        
        for e in graph.edgesForIndex(v) {
            if !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                pathDict[e.v] = e
            }
        }
    }
    // figure out route of edges based on pathDict
    if found {
        return pathDictToPath(from, to: to, pathDict: pathDict)
    }
    
    return []
}

/// Find a route from one vertex to another using a breadth first search.
///
/// :params: from The starting vertex.
/// :params: to The ending vertex.
/// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
public func bfs<T: Equatable>(from: T, to: T, graph: Graph<T>) -> [Edge] {
    if let u = graph.indexOfVertex(from) {
        if let v = graph.indexOfVertex(to) {
            return bfs(u, to: v, graph: graph)
        }
    }
    return []
}

/// Utility function that takes an array of Edges and converts it to an ordered list of vertices
///
/// :params: edges Array of edges to convert.
/// :params: graph The graph the edges exist within.
/// - returns: An array of vertices from the graph.
public func edgesToVertices<T: Equatable>(edges: [Edge], graph: Graph<T>) -> [T] {
    var vs: [T] = [T]()
    if let first = edges.first {
        vs.append(graph.vertexAtIndex(first.u))
        vs += edges.map({graph.vertexAtIndex($0.v)})
    }
    return vs
}

//version for Dijkstra with weighted edges
public func edgesToVertices<T: Equatable, W: protocol<Comparable, Summable>>(edges: [WeightedEdge<W>], graph: Graph<T>) -> [T] {
    var vs: [T] = [T]()
    if let first = edges.first {
        vs.append(graph.vertexAtIndex(first.u))
        vs += edges.map({graph.vertexAtIndex($0.v)})
    }
    return vs
}

/// Finds the shortest paths from some route vertex to every other vertex in the graph. Note this doesn't yet use a priority queue, so it is very slow.
///
/// :params: graph The WeightedGraph to look within.
/// :params: root The index of the root node to build the shortest paths from.
/// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each vertex. Use the function pathDictToPath() to convert the dictionary into something useful for a specific point.
public func dijkstra<T: Equatable, W: protocol<Comparable, Summable>> (graph: WeightedGraph<T, W>, root: Int) -> ([W?], [Int: WeightedEdge<W>]) {
    var distances: [W?] = [W?](count: graph.vertexCount, repeatedValue: nil)
    let queue: Queue<Int> = Queue<Int>()
    var pathDict: [Int: WeightedEdge<W>] = [Int: WeightedEdge<W>]()
    queue.push(root)

    while !queue.isEmpty {
        let u: Int = queue.pop()
        
        for e in graph.edgesForIndex(u) {
            if let we = e as? WeightedEdge<W> {
                //if queue.contains(we.v) {
                    var alt: W
                    if let dist = distances[we.u] {
                        alt = we.weight + dist
                    } else {
                        alt = we.weight
                    }
                    if let dist = distances[we.v] {
                        if alt < dist {
                            distances[we.v] = alt
                            pathDict[we.v] = we
                        }
                    } else {
                        if !(we.v == root) {
                            distances[we.v] = alt
                            pathDict[we.v] = we
                            queue.push(we.v)
                        }
                    }
                //}
            }
        }
    }
    
    return (distances, pathDict)
}

public func dijkstra<T: Equatable, W: protocol<Comparable, Summable>> (graph: WeightedGraph<T, W>, root: T) -> ([W?], [Int: WeightedEdge<W>]) {
    if let u = graph.indexOfVertex(root) {
        return dijkstra(graph, root: u)
    }
    return ([], [:])
}

/// Helper function to get easier access to Dijkstra results.
public func distanceArrayToVertexDict<T: Equatable, W: protocol<Comparable, Summable>>(distances: [W?], graph: WeightedGraph<T, W>) -> [T : W?] {
    var distanceDict: [T: W?] = [T: W?]()
    for var i = 0; i < distances.count; i++ {
        distanceDict[graph.vertexAtIndex(i)] = distances[i]
    }
    return distanceDict
}