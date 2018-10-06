//
//  Search.swift
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

/// Functions for searching a graph & utility functions for supporting them

public typealias DFS<G: Graph> = Search<G, Stack<G.E>>
public typealias BFS<G: Graph> = Search<G, Queue<G.E>>

/// This class implements the depth-first search algorithms
public struct Search<G: Graph, C: EdgeContainer> where C.E == G.E {
    public typealias V = G.V
    public typealias E = G.E

    /// The graph on which the search or computation will be performed
    public let graph: G

    /// This closure lets you customize the order in which the graph is traversed.
    /// It takes as a parameter the edges with origin on the visited vertex
    /// and it must output the same set of edges in desired visiting order.
    public var visitOrder: ([E]) -> [E] = { $0 }

    /// Create a DSL object to perform a dsl search or computation on a graph.
    ///
    /// - Parameter graph: The graph on which the search or computation will be performed
    public init(on graph: G) {
        self.graph = graph
    }

    /// Return a new DFS object with visitOrder set to the passed closure
    ///
    /// - Parameter visitOrder: The visi orrder of the new DSL
    /// - Returns: A new DFS object with visitOrder set to the passed closure
    public func withVisitOrder(_ visitOrder: @escaping ([E]) -> [E]) -> Search {
        var dfs = Search(on: graph)
        dfs.visitOrder = visitOrder
        return dfs
    }

    /// Perform a computation over the graph visiting the vertices using a
    /// depth-first algorithm.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex index is a goal.
    /// - parameter reducer: A reducer that is fed with each visited vertex. The input parameter
    ///                      is the edge from the previous vertex to the visited vertex.
    /// - returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    public func from(_ initalVertex: Int, goalTest: (Int) -> Bool, reducer: (E)->()) -> Int? {
        // Setup

        if goalTest(initalVertex) {
            return initalVertex
        }

        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container: C = C()

        func visitNeighbours(v: Int) {
            var neighbours = visitOrder(graph.edgesForIndex(v))
            if !C.isFIFO { neighbours.reverse() }
            for e in neighbours {
                if !visited[e.v] {
                    container.push(e)
                    visited[e.v] = true
                }
            }
        }

        // Dfs

        visited[initalVertex] = true
        visitNeighbours(v: initalVertex)

        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            reducer(edge)
            if goalTest(v) {
                return v
            }
            visitNeighbours(v: v)
        }
        return nil // no route found
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex index is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func from(_ initalVertex: Int, goalTest: (Int) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var pathDict:[Int: E] = [:]
        let result = from(initalVertex, goalTest: goalTest, reducer: { (e: E) -> Void in
            pathDict[e.v] = e
        })
        if let vertexFound = result {
            return pathDictToPath(from: initalVertex, to: vertexFound, pathDict: pathDict) as! [E]
        }
        return []
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func from(_ initalVertex: Int, goalTest: (V) -> Bool) -> [E] {
        return from(initalVertex, goalTest: { goalTest(graph.vertexAtIndex($0)) })
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func from(_ initalVertex: V, goalTest: (V) -> Bool) -> [E] {
        if let u = graph.indexOfVertex(initalVertex) {
            return from(u, goalTest: goalTest)
        }
        return []
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter to: The index of the ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func from(_ initalVertex: Int, to: Int) -> [E] {
        return from(initalVertex, goalTest: { $0 == to })
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func from(_ initalVertex: V, to: V) -> [E] {
        if let u = graph.indexOfVertex(initalVertex) {
            if let v = graph.indexOfVertex(to) {
                return from(u, to: v)
            }
        }
        return []
    }

    /// Visit all reachable vertices from the initial vertex in depth-first search order
    /// and execute a closure on each visited vertex.
    ///
    /// - Parameters:
    ///   - initalVertex: The index of the initial vertex
    ///   - closure: The closure to execute on each visited vertex. Takes the index of
    ///              the visited vertex as input parameter
    public func visit(from initalVertex: Int, executing closure: @escaping (Int)->()) {
        closure(initalVertex)
        _ = from(initalVertex, goalTest: { _ in false }, reducer: { closure($0.v) })
    }

    /// Visit all reachable vertices from the initial vertex in depth-first search order
    /// and execute a closure on each visited vertex.
    ///
    /// - Parameters:
    ///   - initalVertex: The index of the initial vertex
    ///   - closure: The closure to execute on each visited vertex.
    ///              Takes the visited vertex as input parameter.
    public func visit(from initalVertex: V, executing closure: @escaping (V)->()) {
        guard let v = graph.indexOfVertex(initalVertex) else { return }
        visit(from: v, executing: { closure(self.graph.vertexAtIndex($0))})
    }
}

// MARK: Depth-First Search and Breadth-First Search Extensions to `Graph`
//       These are convenience methods that construct the appropiate DFS object for self
public extension Graph {

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// The order in which the neighbours of a vertex are visited is undetermined.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: V, goalTest: (V) -> Bool) -> [E] {
        return DFS(on: self).from(from, goalTest: goalTest)
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// The order in which the neighbours of a vertex are visited is undetermined.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: V, to: V) -> [E] {
        return DFS(on: self).from(from, to: to)
    }

    /// Visit all reachable vertices from the initial vertex in depth-first search order
    /// and execute a closure on each visited vertex.
    ///
    /// The order in which the neighbours of a vertex are visited is undetermined.
    ///
    /// - Parameters:
    ///   - initalVertex: The index of the initial vertex
    ///   - closure: The closure to execute on each visited vertex.
    ///              Takes the visited vertex as input parameter.
    public func visitDfs(from: V, executing closure: @escaping (V)->()) {
        DFS(on: self).visit(from: from, executing: closure)
    }
    
    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: V, goalTest: (V) -> Bool) -> [E] {
        return BFS(on: self).from(from, goalTest: goalTest)
    }

    /// Find a route from one vertex to another using a breadth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: V, to: V) -> [E] {
        return BFS(on: self).from(from, to: to)
    }

    /// Visit all reachable vertices from the initial vertex in breadth-first search order
    /// and execute a closure on each visited vertex.
    ///
    /// The order in which the neighbours of a vertex are visited is undetermined.
    ///
    /// - Parameters:
    ///   - initalVertex: The index of the initial vertex
    ///   - closure: The closure to execute on each visited vertex.
    ///              Takes the visited vertex as input parameter.
    public func visitBfs(from: V, executing closure: @escaping (V)->()) {
        DFS(on: self).visit(from: from, executing: closure)
    }
    
    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be found
    public func findAll(from: Int, goalTest: (V) -> Bool) -> [[E]] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        var paths: [[Edge]] = [[Edge]]()
        queue.push(from)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                paths.append(pathDictToPath(from: from, to: v, pathDict: pathDict))
            }
            
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    visited[e.v] = true
                    queue.push(e.v)
                    pathDict[e.v] = e
                }
            }
        }
        return paths as! [[Self.E]]
    }
    
    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be founding the entire route, or an empty array if no route could be found
    public func findAll(from: V, goalTest: (V) -> Bool) -> [[E]] {
        if let u = indexOfVertex(from) {
            return findAll(from: u, goalTest: goalTest)
        }
        return []
    }
}

//MARK: `WeightedGraph` extension for doing dijkstra

public extension WeightedGraph {

    /// Finds the shortest paths from some route vertex to every other vertex in the graph.
    ///
    /// - parameter graph: The WeightedGraph to look within.
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each vertex. Use the function pathDictToPath() to convert the dictionary into something useful for a specific point.
    public func dijkstra( root: Int, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
        var distances: [W?] = [W?](repeating: nil, count: vertexCount) // how far each vertex is from start
        distances[root] = startDistance // the start vertex is startDistance away
        var pq: PriorityQueue<DijkstraNode<W>> = PriorityQueue<DijkstraNode<W>>(ascending: true)
        var pathDict: [Int: WeightedEdge<W>] = [Int: WeightedEdge<W>]() // how we got to each vertex
        pq.push(DijkstraNode(vertex: root, distance: startDistance))
        
        while let u = pq.pop()?.vertex { // explore the next closest vertex
            guard let distU = distances[u] else { continue } // should already have seen it
            for we in edgesForIndex(u)  { // look at every edge/vertex from the vertex in question
                let distV = distances[we.v] // the old distance to this vertex
                if distV == nil || distV! > we.weight + distU { // if we have no old distance or we found a shorter path
                    distances[we.v] = we.weight + distU // update the distance to this vertex
                    pathDict[we.v] = we // update the edge on the shortest path to this vertex
                    pq.push(DijkstraNode(vertex: we.v, distance: we.weight + distU)) // explore it soon
                }
            }
        }
        
        return (distances, pathDict)
    }


    /// A convenience version of dijkstra() that allows the supply of the root
    /// vertex instead of the index of the root vertex.
    public func dijkstra(root: V, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
        if let u = indexOfVertex(root) {
            return dijkstra(root: u, startDistance: startDistance)
        }
        return ([], [:])
    }
}

//MARK: Dijkstra Utilites

/// Represents a node in the priority queue used
/// for selecting the next
struct DijkstraNode<D: Comparable>: Comparable, Equatable {
    let vertex: Int
    let distance: D
    
    static func < <D>(lhs: DijkstraNode<D>, rhs: DijkstraNode<D>) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    static func == <D>(lhs: DijkstraNode<D>, rhs: DijkstraNode<D>) -> Bool {
        return lhs.distance == rhs.distance
    }
}


/// Helper function to get easier access to Dijkstra results.
public func distanceArrayToVertexDict<T, W>(distances: [W?], graph: WeightedGraph<T, W>) -> [T : W?] {
    var distanceDict: [T: W?] = [T: W?]()
    for i in 0..<distances.count {
        distanceDict[graph.vertexAtIndex(i)] = distances[i]
    }
    return distanceDict
}



//version for Dijkstra with weighted edges
extension Graph {
    public func edgesToVertices(edges: [E]) -> [V] {
        var vs: [V] = [V]()
        if let first = edges.first {
            vs.append(vertexAtIndex(first.u))
            vs += edges.map({vertexAtIndex($0.v)})
        }
        return vs
    }
}

/// Takes a dictionary of edges to reach each node and returns an array of edges
/// that goes from `from` to `to`
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
    return Array(edgePath.reversed())
}

// version for Dijkstra
public func pathDictToPath<W>(from: Int, to: Int, pathDict:[Int:WeightedEdge<W>]) -> [WeightedEdge<W>] {
    var edgePath: [WeightedEdge<W>] = [WeightedEdge<W>]()
    var e: WeightedEdge<W> = pathDict[to]!
    edgePath.append(e)
    while (e.u != from) {
        e = pathDict[e.u]!
        edgePath.append(e)
    }
    return Array(edgePath.reversed())
}
