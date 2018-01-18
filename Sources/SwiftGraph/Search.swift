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

// MARK: Depth-First Search

extension Graph {
    /// Find a route from a node to the first that satisfies test()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: Int, until test: (N) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        let stack: Stack<Int> = Stack<Int>()
        var path: [Int: E] = [Int: E]()
        stack.push(from)
        while !stack.isEmpty {
            let to: Int = stack.pop()
            if test(node(at: to)) {
                // figure out route of edges based on path
                return route(from, to, in: path)
            }
            visited[to] = true
            for e in edges(for: to) where !visited[e.v] {
                stack.push(e.v)
                path[e.v] = e
            }
        }
        return [] // no route found
    }

    /// Find a route from a node to the first that satisfies test()
    /// using a depth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: N, until test: (N) -> Bool) -> [E] {
        guard let u = index(of: from) else { return [] }
        return dfs(from: u, until: test)
    }

    /// Find a route from one node to another using a depth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter to: The index of the ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: Int, to: Int) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        let stack: Stack<Int> = Stack<Int>()
        var path: [Int: E] = [Int: E]()
        stack.push(from)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if v == to {
                // figure out route of edges based on path
                return route(from, to, in: path)
            }
            visited[v] = true
            for e in edges(for: v) where !visited[e.v] {
                stack.push(e.v)
                path[e.v] = e
            }
        }
        return [] // no solution found
    }

    /// Find a route from one node to another using a depth-first search.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from: N, to: N) -> [E] {
        guard let (u, v) = indices(of: from, to) else { return [] }
        return dfs(from: u, to: v)
    }
}

// MARK: Breadth-First Search

extension Graph {
    /// Find a route from a node to the first that satisfies test()
    /// using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: Int, until test: (N) -> Bool) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: E] = [Int: E]()
        queue.push(from)
        while !queue.isEmpty {
            let to: Int = queue.pop()
            if test(node(at: to)) {
                // figure out route of edges based on path
                return route(from, to, in: path)
            }

            for e in edges(for: to) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                path[e.v] = e
            }
        }
        return [] // no path found
    }

    /// Find a route from a node to the first that satisfies test()
    /// using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: N, until test: (N) -> Bool) -> [E] {
        guard let u = index(of: from) else { return [] }
        return bfs(from: u, until: test)
    }

    /// Find a route from one node to another using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter to: The index of the ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: Int, to: Int) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: E] = [Int: E]()
        queue.push(from)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if v == to {
                // figure out route of edges based on path
                return route(from, to, in: path)
            }

            for e in edges(for: v) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                path[e.v] = e
            }
        }
        return []
    }

    /// Find a route from one node to another using a breadth-first search.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from: N, to: N) -> [E] {
        guard let (u, v) = indices(of: from, to) else { return [] }
        return bfs(from: u, to: v)
    }
}

// MARK: Route Search

extension Graph {
    /// Find path routes from a node to all others the
    /// function test() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of arrays of Edges containing routes to every node connected and passing test(), or an empty array if no routes could be found
    public func routes(from: Int, until test: (N) -> Bool) -> [[E]] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        let queue: Queue<Int> = Queue<Int>()
        var path: [Int: E] = [Int: E]()
        var paths: [[E]] = [[E]]()
        queue.push(from)
        while !queue.isEmpty {
            let to: Int = queue.pop()
            if test(node(at: to)) {
                // figure out route of edges based on path
                paths.append(route(from, to, in: path))
            }

            for e in edges(for: to) where !visited[e.v] {
                visited[e.v] = true
                queue.push(e.v)
                path[e.v] = e
            }
        }
        return paths
    }

    /// Find path routes from a node to all others the
    /// function test() returns true for using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter test: Returns true if a given node is a goal.
    /// - returns: An array of arrays of Edges containing routes to every node connected and passing test(), or an empty array if no routes could be founding the entire route, or an empty array if no route could be found
    public func routes(from: N, until test: (N) -> Bool) -> [[E]] {
        guard let u = index(of: from) else { return [] }
        return routes(from: u, until: test)
    }
}

extension Graph {
    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(from: N, to: N, in path: [Int: E]) -> [E] {
        guard !path.isEmpty, let from = index(of: from), let to = index(of: to) else { return [] }
        return route(from, to, in: path)
    }

    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(_ from: Int, _ to: Int, in path: [Int: E]) -> [E] {
        guard !path.isEmpty else { return [] }
        var edgePath: [E] = [E]()
        var e: E = path[to]!
        edgePath.append(e)
        while e.u != from {
            e = path[e.u]!
            edgePath.append(e)
        }
        return Array(edgePath.reversed())
    }
}

// MARK: Dijkstra Algorithm

public extension WeightedGraph {
    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(root: Int, start distance: W) -> ([W?], [Int: E]) {
        var distances: [W?] = [W?](repeating: nil, count: nodeCount) // how far each node is from start
        distances[root] = distance // the start node is startDistance away
        var pq: PriorityQueue<DijkstraNode<W>> = PriorityQueue<DijkstraNode<W>>(ascending: true)
        var path: [Int: E] = [Int: E]() // how we got to each node
        pq.push(DijkstraNode(node: root, distance: distance))

        while let u = pq.pop()?.node { // explore the next closest node
            guard let distU = distances[u] else { continue } // should already have seen it
            for we in edges(for: u) { // look at every edge/node from the node in question
                let distV = distances[we.v] // the old distance to this node
                if distV == nil || distV! > we.weight + distU { // if we have no old distance or we found a shorter path
                    distances[we.v] = we.weight + distU // update the distance to this node
                    path[we.v] = we // update the edge on the shortest path to this node
                    pq.push(DijkstraNode(node: we.v, distance: we.weight + distU)) // explore it soon
                }
            }
        }

        return (distances, path)
    }

    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// A convenience version that allows the supply of the root node instead of the index
    /// of the root node.
    ///
    /// - parameter root: The node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(root: N, start distance: W) -> ([W?], [Int: E]) {
        guard let u = index(of: root) else { return ([], [:]) }
        return dijkstra(root: u, start: distance)
    }

    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// A convenience version that returns a dictionary with the node and the distance.
    ///
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, a dictionary containing the distances associated with the nodes, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(root: Int, start distance: W) -> ([N: W?], [Int: E]) {
        let (distances, edges): ([W?], [Int: E]) = dijkstra(root: root, start: distance)
        var distance: [N: W?] = .init()
        for i in 0 ..< distances.count {
            distance[node(at: i)] = distances[i]
        }
        return (distance, edges)
    }

    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// A convenience version that returns a dictionary with the node and the distance,
    /// starting from a node instead of an index.
    ///
    /// - parameter root: The node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, a dictionary containing the distances associated with the nodes, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(root: N, start distance: W) -> ([N: W?], [Int: E]) {
        guard let u = index(of: root) else { return ([:], [:]) }
        return dijkstra(root: u, start: distance)
    }
}

/// Represents a node in the priority queue used for selecting the next
struct DijkstraNode<D: Comparable>: Comparable, Equatable {
    let node: Int
    let distance: D

    static func < <D>(lhs: DijkstraNode<D>, rhs: DijkstraNode<D>) -> Bool {
        return lhs.distance < rhs.distance
    }

    static func == <D>(lhs: DijkstraNode<D>, rhs: DijkstraNode<D>) -> Bool {
        return lhs.distance == rhs.distance
    }
}

// MARK: Search Utilities

extension Graph {
    /// Takes an array of `Edge`s and converts it to an ordered list of nodes.
    ///
    /// - parameter edges: Array of edges to convert.
    /// - returns: An array of nodes from the graph.
    public func nodes(from edges: [E]) -> [N] {
        var vs: [N] = [N]()
        if let first = edges.first {
            vs.append(node(at: first.u))
            vs += edges.map { node(at: $0.v) }
        }
        return vs
    }
}
