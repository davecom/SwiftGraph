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

// MARK: Depth-First Search and Breadth-First Search Extensions to `Graph`

public extension Graph {

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: Int, goalTest: (V) -> Bool) -> [Edge] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var path: [Int: Edge] = [Int: Edge]()
        stack.push(from)
        while !stack.isEmpty {
            let to: Int = stack.pop()
            if goalTest(vertexAtIndex(to)) {
                // figure out route of edges based on pathDict
                return route(from, to, in: path)
            }
            visited[to] = true
            for e in edgesForIndex(to) where !visited[e.v] {
                stack.push(e.v)
                pathDict[e.v] = e
            }
        }
        return [] // no route found
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: V, goalTest: (V) -> Bool) -> [Edge] {
        if let u = indexOfVertex(from) {
            return dfs(from: u, goalTest: goalTest)
        }
        return []
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter to: The index of the ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: Int, to: Int) -> [Edge] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var path: [Int: Edge] = [Int: Edge]()
        stack.push(from)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if v == to {
                // figure out route of edges based on pathDict
                return route(from, to, in: path)
            }
            visited[v] = true
            for e in edgesForIndex(v) where !visited[e.v] {
                stack.push(e.v)
                pathDict[e.v] = e
            }
        }
        return [] // no solution found
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: V, to: V) -> [Edge] {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return dfs(from: u, to: v)
            }
        }
        return []
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: Int, goalTest: (V) -> Bool) -> [Edge] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: Edge] = [Int: Edge]()
        queue.push(from)
        while !queue.isEmpty {
            let to: Int = queue.pop()
            if goalTest(vertexAtIndex(to)) {
                // figure out route of edges based on pathDict
                return route(from, to, in: path)
            }

            for e in edgesForIndex(to) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                pathDict[e.v] = e
            }
        }
        return [] // no path found
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: V, goalTest: (V) -> Bool) -> [Edge] {
        if let u = indexOfVertex(from) {
            return bfs(from: u, goalTest: goalTest)
        }
        return []
    }

    /// Find a route from one vertex to another using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter to: The index of the ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: Int, to: Int) -> [Edge] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: Edge] = [Int: Edge]()
        queue.push(from)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if v == to {
                // figure out route of edges based on pathDict
                return route(from, to, in: path)
            }

            for e in edgesForIndex(v) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                pathDict[e.v] = e
            }
        }
        return []
    }

    /// Find a route from one vertex to another using a breadth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: V, to: V) -> [Edge] {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return bfs(from: u, to: v)
            }
        }
        return []
    }

    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be found
    public func findAll(from: Int, goalTest: (V) -> Bool) -> [[Edge]] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: Edge] = [Int: Edge]()
        var paths: [[Edge]] = [[Edge]]()
        queue.push(from)
        while !queue.isEmpty {
            let to: Int = queue.pop()
            if goalTest(vertexAtIndex(to)) {
                // figure out route of edges based on pathDict
                paths.append(route(from, to, in: path))
            }

            for e in edgesForIndex(to) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                pathDict[e.v] = e
            }
        }
        return paths
    }

    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be founding the entire route, or an empty array if no route could be found
    public func findAll(from: V, goalTest: (V) -> Bool) -> [[Edge]] {
        if let u = indexOfVertex(from) {
            return findAll(from: u, goalTest: goalTest)
        }
        return []
    }
}

// MARK: `WeightedGraph` extension for doing dijkstra

public extension WeightedGraph {

    /// Finds the shortest paths from some route vertex to every other vertex in the graph.
    ///
    /// - parameter graph: The WeightedGraph to look within.
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each vertex. Use the function pathDictToPath() to convert the dictionary into something useful for a specific point.
    public func dijkstra(root: Int, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
        var distances: [W?] = [W?](repeating: nil, count: vertexCount) // how far each vertex is from start
        distances[root] = startDistance // the start vertex is startDistance away
        var pq: PriorityQueue<DijkstraNode<W>> = PriorityQueue<DijkstraNode<W>>(ascending: true)
        var path: [Int: WeightedEdge<W>] = [Int: WeightedEdge<W>]() // how we got to each vertex
        pq.push(DijkstraNode(vertex: root, distance: startDistance))

        while let u = pq.pop()?.vertex { // explore the next closest vertex
            guard let distU = distances[u] else { continue } // should already have seen it
            for we in edgesForIndex(u) as! [WeightedEdge<W>] { // look at every edge/vertex from the vertex in question
                let distV = distances[we.v] // the old distance to this vertex
                if distV == nil || distV! > we.weight + distU { // if we have no old distance or we found a shorter path
                    distances[we.v] = we.weight + distU // update the distance to this vertex
                    path[we.v] = we // update the edge on the shortest path to this vertex
                    pq.push(DijkstraNode(vertex: we.v, distance: we.weight + distU)) // explore it soon
                }
            }
        }

        return (distances, path)
    }

    /// A convenience version of dijkstra() that allows the supply of the root
    /// vertex instead of the index of the root vertex.
    public func dijkstra(root: T, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
        if let u = indexOfVertex(root) {
            return dijkstra(root: u, startDistance: startDistance)
        }
        return ([], [:])
    }
}

// MARK: Dijkstra Utilites

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

public extension WeightedGraph {
    /// Get easier access to Dijkstra results.
    public func distanceArrayToVertexDict(distances: [W?]) -> [T: W?] {
        var distanceDict: [T: W?] = .init()
        for i in 0 ..< distances.count {
            distanceDict[vertexAtIndex(i)] = distances[i]
        }
        return distanceDict
    }
}

public extension Graph {
    /// Takes an array of `Edge`s and converts it to an ordered list of vertices.
    ///
    /// - parameter edges: Array of edges to convert.
    /// - returns: An array of vertices from the graph.
    public func edgesToVertices(edges: [Edge]) -> [V] {
        var vs: [V] = [V]()
        if let first = edges.first {
            vs.append(vertexAtIndex(first.u))
            vs += edges.map({ vertexAtIndex($0.v) })
        }
        return vs
    }
}

public extension WeightedGraph {
    /// Takes an array of `WeightedEdge`s and converts it to an ordered list of vertices.
    ///
    /// - parameter edges: Array of weighted edges to convert.
    /// - returns: An array of vertices from the graph.
    public func edgesToVertices(edges: [WeightedEdge<W>]) -> [T] {
        var vs: [T] = [T]()
        if let first = edges.first {
            vs.append(vertexAtIndex(first.u))
            vs += edges.map({ vertexAtIndex($0.v) })
        }
        return vs
    }
}

public extension Graph {
    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(from: V, to: V, in path: [Int: Edge]) -> [Edge] {
        guard !path.isEmpty, let from = indexOfVertex(from), let to = indexOfVertex(to) else { return [] }
        return route(from, to, in: path)
    }

    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(_ from: Int, _ to: Int, in path: [Int: Edge]) -> [Edge] {
        guard !path.isEmpty else { return [] }
        var edgePath: [Edge] = [Edge]()
        var e: Edge = path[to]!
        edgePath.append(e)
        while e.u != from {
            e = path[e.u]!
            edgePath.append(e)
        }
        return Array(edgePath.reversed())
    }
}

public extension WeightedGraph {
    /// Takes a dictionary of `WeightedEdge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(from: T, to: T, in path: [Int: WeightedEdge<W>]) -> [WeightedEdge<W>] {
        guard !path.isEmpty, let from = indexOfVertex(from), let to = indexOfVertex(to) else { return [] }
        return route(from, to, in: path)
    }

    /// Takes a dictionary of `WeightedEdge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(_ from: Int, _ to: Int, in path: [Int: WeightedEdge<W>]) -> [WeightedEdge<W>] {
        guard !path.isEmpty else { return [] }
        var edgePath: [WeightedEdge<W>] = [WeightedEdge<W>]()
        var e: WeightedEdge<W> = path[to]!
        edgePath.append(e)
        while e.u != from {
            e = path[e.u]!
            edgePath.append(e)
        }
        return Array(edgePath.reversed())
    }
}
