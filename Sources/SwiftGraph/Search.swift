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
    public func dfs(_ source: Int, until at: (N) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        var path: [Int: E] = .init()
        let stack: Stack<Int> = .init()
        stack.push(source)

        while !stack.isEmpty {
            let target: Int = stack.pop()
            if at(node(at: target)) { return route(source, target, in: path) }

            visited[target] = true
            for edge in edges[target] where !visited[edge.target] {
                stack.push(edge.target)
                path[edge.target] = edge
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
    public func dfs(from source: N, until at: (N) -> Bool) -> [E] {
        guard let source = index(of: source) else { return [] }
        return dfs(source, until: at)
    }

    /// Find a route from one node to another using a depth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter to: The index of the ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(_ source: Int, _ target: Int) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        var path: [Int: E] = .init()
        let stack: Stack<Int> = .init()
        stack.push(source)

        while !stack.isEmpty {
            let current: Int = stack.pop()
            if current == target { return route(source, target, in: path) }

            visited[current] = true
            for edge in edges[current] where !visited[edge.target] {
                stack.push(edge.target)
                path[edge.target] = edge
            }
        }

        return [] // no solution found
    }

    /// Find a route from one node to another using a depth-first search.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func dfs(from source: N, to target: N) -> [E] {
        guard let (source, target) = indices(of: source, target) else { return [] }
        return dfs(source, target)
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
    public func bfs(_ source: Int, until at: (N) -> Bool) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        var path: [Int: E] = .init()
        let queue: Queue<Int> = .init()
        queue.push(source)

        while !queue.isEmpty {
            let target: Int = queue.pop()
            if at(node(at: target)) { return route(source, target, in: path) }

            for edge in edges[target] where !visited[edge.target] {
                visited[edge.target] = true
                queue.push(edge.target)
                path[edge.target] = edge
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
    public func bfs(from source: N, until at: (N) -> Bool) -> [E] {
        guard let source = index(of: source) else { return [] }
        return bfs(source, until: at)
    }

    /// Find a route from one node to another using a breadth-first search.
    ///
    /// - parameter from: The index of the starting node.
    /// - parameter to: The index of the ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(_ source: Int, _ target: Int) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        var path: [Int: E] = .init()
        let queue: Queue<Int> = .init()
        queue.push(source)

        while !queue.isEmpty {
            let current: Int = queue.pop()
            if current == target { return route(source, target, in: path) }

            for edge in edges[current] where !visited[edge.target] {
                visited[edge.target] = true
                queue.push(edge.target)
                path[edge.target] = edge
            }
        }

        return []
    }

    /// Find a route from one node to another using a breadth-first search.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    public func bfs(from source: N, to target: N) -> [E] {
        guard let (source, target) = indices(of: source, target) else { return [] }
        return bfs(source, target)
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
    public func routes(_ source: Int, until at: (N) -> Bool) -> [[E]] {
        // pretty standard bfs that doesn't visit anywhere twice; path tracks route
        var visited: [Bool] = [Bool](repeating: false, count: nodeCount)
        var path: [Int: E] = .init()
        var paths: [[E]] = .init()
        let queue: Queue<Int> = .init()
        queue.push(source)

        while !queue.isEmpty {
            let target: Int = queue.pop()
            if at(node(at: target)) { paths.append(route(source, target, in: path)) }

            for edge in edges[target] where !visited[edge.target] {
                visited[edge.target] = true
                queue.push(edge.target)
                path[edge.target] = edge
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
    public func routes(from source: N, until at: (N) -> Bool) -> [[E]] {
        guard let source = index(of: source) else { return [] }
        return routes(source, until: at)
    }
}

extension Graph {
    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(_ source: Int, _ target: Int, in path: [Int: E]) -> [E] {
        guard !path.isEmpty else { return [] }
        var edge: E = path[target]!
        var edgePath: [E] = [edge]

        while edge.source != source {
            edge = path[edge.source]!
            edgePath.append(edge)
        }

        return Array(edgePath.reversed())
    }

    /// Takes a dictionary of `Edge` to reach each node and returns an array of edges that goes from `from` to `to`.
    public func route(from source: N, to target: N, in path: [Int: E]) -> [E] {
        guard !path.isEmpty, let (source, target) = indices(of: source, target) else { return [] }
        return route(source, target, in: path)
    }
}

// MARK: Dijkstra Algorithm

public extension WeightedGraph {
    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(_ root: Int, start distance: W) -> ([W?], [Int: E]) {
        var distances: [W?] = .init(repeating: nil, count: nodeCount) // how far each node is from start
        distances[root] = distance // the start node is startDistance away
        var path: [Int: E] = .init() // how we got to each node
        var queue: PriorityQueue<DijkstraNode<W>> = .init(ascending: true)
        queue.push(DijkstraNode(node: root, distance: distance))

        while let source = queue.pop()?.node { // explore the next closest node
            guard let new = distances[source] else { continue } // should already have seen it
            for edge in edges[source] { // look at every edge/node from the node in question
                let old = distances[edge.target] // the old distance to this node
                if old == nil || old! > edge.weight + new { // if we have no old distance or we found a shorter path
                    distances[edge.target] = edge.weight + new // update the distance to this node
                    path[edge.target] = edge // update the edge on the shortest path to this node
                    queue.push(DijkstraNode(node: edge.target, distance: edge.weight + new)) // explore it soon
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
    public func dijkstra(from root: N, start distance: W) -> ([W?], [Int: E]) {
        guard let root = index(of: root) else { return ([], [:]) }
        return dijkstra(root, start: distance)
    }

    /// Finds the shortest paths from some route node to every other node in the graph.
    ///
    /// A convenience version that returns a dictionary with the node and the distance.
    ///
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, a dictionary containing the distances associated with the nodes, the second, a dictionary containing the edge to reach each node. Use `route(from:to:in)` to convert the dictionary into something useful for a specific point.
    public func dijkstra(_ root: Int, start distance: W) -> ([N: W?], [Int: E]) {
        let (distances, edges): ([W?], [Int: E]) = dijkstra(root, start: distance)
        var distance: [N: W?] = .init()
        distances.enumerated().forEach {
            distance[node(at: $0.offset)] = $0.element
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
    public func dijkstra(from root: N, start distance: W) -> ([N: W?], [Int: E]) {
        guard let root = index(of: root) else { return ([:], [:]) }
        return dijkstra(root, start: distance)
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
        var nodes: [N] = .init()
        if let first = edges.first {
            nodes.append(node(at: first.source))
            nodes += edges.map { node(at: $0.target) }
        }
        return nodes
    }
}
