//
//  Search.swift
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

/// Functions for searching a graph & utility functions for supporting them

// MARK: Depth-First Search and Breadth-First Search Extensions to `Graph`
public extension Graph {

    /// Perform a computation over the graph visiting the vertices using a
    /// depth-first algorithm.
    ///
    /// The vertices of the graph are visited one time at most.
    ///
    /// - Parameters:
    ///   - initalVertexIndex: The index of the vertex that will be visited first.
    ///   - goalTest: Returns true if a given vertex index is a goal.
    ///   - visitOrder: A closure that orders an array of edges. For each visited vertex, the array
    ///                 of its outgoing edges will be passed to this closure and the neighbours will
    ///                 be visited in the order of the resulting array.
    ///   - reducer: A closure that is fed with each visited edge. The input parameter
    ///              is the edge from the previously visited vertex to the currently visited vertex.
    ///              If the return value is false, the neighbours of the currently visited vertex won't be visited.
    /// - Returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    func dfs(fromIndex initalVertexIndex: Int,
             goalTest: (Int) -> Bool,
             visitOrder: ([E]) -> [E],
             reducer: (E) -> Bool) -> Int? {

        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let container = Stack<E>()

        visited[initalVertexIndex] = true
        let neighbours = edgesForIndex(initalVertexIndex)
        for e in visitOrder(neighbours) {
            if !visited[e.v] {
                container.push(e)
            }
        }
        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            if visited[v] {
                continue
            }
            let shouldVisitNeighbours = reducer(edge)
            if goalTest(v) {
                return v
            }
            if shouldVisitNeighbours {
                visited[v] = true
                let neighbours = edgesForIndex(v)
                for e in visitOrder(neighbours) {
                    if !visited[e.v] {
                        container.push(e)
                    }
                }
            }
        }
        return nil // no route found
    }

    /// Perform a computation over the graph visiting the vertices using a
    /// depth-first algorithm.
    ///
    /// The vertices of the graph can be visited more than once. This means that the algorithm is
    /// not guaranteed to terminate if tha graph has cycles, it dependes on what goalTest and reducer are used.
    ///
    /// - Parameters:
    ///   - initalVertexIndex: The index of the vertex that will be visited first.
    ///   - goalTest: Returns true if a given vertex index is a goal.
    ///   - visitOrder: A closure that orders an array of edges. For each visited vertex, the array
    ///                 of its outgoing edges will be passed to this closure and the neighbours will
    ///                 be visited in the order of the resulting array.
    ///   - reducer: A closure that is fed with each visited edge. The input parameter
    ///              is the edge from the previously visited vertex to the currently visited vertex.
    ///              If the return value is false, the neighbours of the currently visited vertex won't be visited.
    /// - Returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    func traverseDfs(fromIndex initalVertexIndex: Int,
                     goalTest: (Int) -> Bool,
                     visitOrder: ([E]) -> [E],
                     reducer: (E) -> Bool) -> Int? {
        
        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }
        let container = Stack<E>()

        let neighbours = edgesForIndex(initalVertexIndex)
        for e in visitOrder(neighbours) {
            container.push(e)
        }
        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            let shouldVisitNeighbours = reducer(edge)
            if goalTest(v) {
                return v
            }
            if shouldVisitNeighbours {
                let neighbours = edgesForIndex(v)
                for e in visitOrder(neighbours) {
                    container.push(e)
                }
            }
        }
        return nil // no route found
    }

    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a depth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func dfs(fromIndex: Int, goalTest: (V) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var pathDict: [Int: E] = [Int: E]()
        stack.push(fromIndex)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if (visited[v]) {
                continue
            }
            visited[v] = true
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                return pathDictToPath(from: fromIndex, to: v, pathDict: pathDict) as! [Self.E]
            }
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    stack.push(e.v)
                    pathDict[e.v] = e
                }
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
    func dfs(from: V, goalTest: (V) -> Bool) -> [E] {
        if let u = indexOfVertex(from) {
            return dfs(fromIndex: u, goalTest: goalTest)
        }
        return []
    }
    
    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter toIndex: The index of the ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func dfs(fromIndex: Int, toIndex: Int) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        stack.push(fromIndex)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if (visited[v]) {
                continue
            }
            visited[v] = true
            if v == toIndex {
                // figure out route of edges based on pathDict
                return pathDictToPath(from: fromIndex, to: toIndex, pathDict: pathDict) as! [Self.E]
            }
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    stack.push(e.v)
                    pathDict[e.v] = e
                }
            }
        }
        return [] // no solution found
    }

    /// Find a route from one vertex to another using a depth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func dfs(from: V, to: V) -> [E] {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return dfs(fromIndex: u, toIndex: v)
            }
        }
        return []
    }

    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a depth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be found
    func findAllDfs(fromIndex: Int, goalTest: (V) -> Bool) -> [[E]] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        var paths: [[Edge]] = [[Edge]]()
        stack.push(fromIndex)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if (visited[v]) {
                continue
            }
            visited[v] = true
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                paths.append(pathDictToPath(from: fromIndex, to: v, pathDict: pathDict))
            }
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    stack.push(e.v)
                    pathDict[e.v] = e
                }
            }
        }
        return paths as! [[Self.E]]
    }

    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a depth-first search.
    ///
    /// - parameter from: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be founding the entire route, or an empty array if no route could be found
    func findAllDfs(from: V, goalTest: (V) -> Bool) -> [[E]] {
        if let u = indexOfVertex(from) {
            return findAllDfs(fromIndex: u, goalTest: goalTest)
        }
        return []
    }

    /// Perform a computation over the graph visiting the vertices using a
    /// breadth-first algorithm.
    ///
    /// The vertices of the graph are visited one time at most.
    ///
    /// - Parameters:
    ///   - initalVertexIndex: The index of the vertex that will be visited first.
    ///   - goalTest: Returns true if a given vertex index is a goal.
    ///   - visitOrder: A closure that orders an array of edges. For each visited vertex, the array
    ///                 of its outgoing edges will be passed to this closure and the neighbours will
    ///                 be visited in the order of the resulting array.
    ///   - reducer: A closure that is fed with each visited edge. The input parameter
    ///              is the edge from the previously visited vertex to the currently visited vertex.
    ///              If the return value is false, the neighbours of the currently visited vertex won't be visited.
    /// - Returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    func bfs(fromIndex initalVertexIndex: Int,
             goalTest: (Int) -> Bool,
             visitOrder: ([E]) -> [E],
             reducer: (E) -> Bool) -> Int? {

        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let container = Queue<E>()

        visited[initalVertexIndex] = true
        let neighbours = edgesForIndex(initalVertexIndex)
        for e in visitOrder(neighbours) {
            if !visited[e.v] {
                container.push(e)
                visited[e.v] = true
            }
        }
        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            let shouldVisitNeighbours = reducer(edge)
            if goalTest(v) {
                return v
            }
            if shouldVisitNeighbours {
                let neighbours = edgesForIndex(v)
                for e in visitOrder(neighbours) {
                    if !visited[e.v] {
                        container.push(e)
                        visited[e.v] = true
                    }
                }
            }
        }
        return nil // no route found
    }

    /// Perform a computation over the graph visiting the vertices using a
    /// breadth-first algorithm.
    ///
    /// The vertices of the graph can be visited more than once. This means that the algorithm is
    /// not guaranteed to terminate if tha graph has cycles, it dependes on what goalTest and reducer are used.
    ///
    /// - Parameters:
    ///   - initalVertexIndex: The index of the vertex that will be visited first.
    ///   - goalTest: Returns true if a given vertex index is a goal.
    ///   - visitOrder: A closure that orders an array of edges. For each visited vertex, the array
    ///                 of its outgoing edges will be passed to this closure and the neighbours will
    ///                 be visited in the order of the resulting array.
    ///   - reducer: A closure that is fed with each visited edge. The input parameter
    ///              is the edge from the previously visited vertex to the currently visited vertex.
    ///              If the return value is false, the neighbours of the currently visited vertex won't be visited.
    /// - Returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    func traverseBfs(fromIndex initalVertexIndex: Int,
                     goalTest: (Int) -> Bool,
                     visitOrder: ([E]) -> [E],
                     reducer: (E) -> Bool) -> Int? {

        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }
        let container = Queue<E>()

        let neighbours = edgesForIndex(initalVertexIndex)
        for e in visitOrder(neighbours) {
            container.push(e)
        }
        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            let shouldVisitNeighbours = reducer(edge)
            if goalTest(v) {
                return v
            }
            if shouldVisitNeighbours {
                let neighbours = edgesForIndex(v)
                for e in visitOrder(neighbours) {
                    container.push(e)
                }
            }
        }
        return nil // no route found
    }


    /// Find a route from a vertex to the first that satisfies goalTest()
    /// using a breadth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func bfs(fromIndex: Int, goalTest: (V) -> Bool) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        queue.push(fromIndex)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                return pathDictToPath(from: fromIndex, to: v, pathDict: pathDict) as! [Self.E]
            }
            
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    visited[e.v] = true
                    queue.push(e.v)
                    pathDict[e.v] = e
                }
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
    func bfs(from: V, goalTest: (V) -> Bool) -> [E] {
        if let u = indexOfVertex(from) {
            return bfs(fromIndex: u, goalTest: goalTest)
        }
        return []
    }
    
    /// Find a route from one vertex to another using a breadth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter toIndex: The index of the ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func bfs(fromIndex: Int, toIndex: Int) -> [E] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        queue.push(fromIndex)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if v == toIndex {
                // figure out route of edges based on pathDict
                return pathDictToPath(from: fromIndex, to: toIndex, pathDict: pathDict) as! [Self.E]
            }
            
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    visited[e.v] = true
                    queue.push(e.v)
                    pathDict[e.v] = e
                }
            }
        }
        return []
    }

    /// Find a route from one vertex to another using a breadth-first search.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
    func bfs(from: V, to: V) -> [E] {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return bfs(fromIndex: u, toIndex: v)
            }
        }
        return []
    }
    
    /// Find path routes from a vertex to all others the
    /// function goalTest() returns true for using a breadth-first search.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(), or an empty array if no routes could be found
    func findAllBfs(fromIndex: Int, goalTest: (V) -> Bool) -> [[E]] {
        // pretty standard bfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let queue: Queue<Int> = Queue<Int>()
        var pathDict: [Int: Edge] = [Int: Edge]()
        var paths: [[Edge]] = [[Edge]]()
        queue.push(fromIndex)
        while !queue.isEmpty {
            let v: Int = queue.pop()
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                paths.append(pathDictToPath(from: fromIndex, to: v, pathDict: pathDict))
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
    func findAllBfs(from: V, goalTest: (V) -> Bool) -> [[E]] {
        if let u = indexOfVertex(from) {
            return findAllBfs(fromIndex: u, goalTest: goalTest)
        }
        return []
    }
}

//MARK: `WeightedGraph` extension for doing dijkstra

public extension WeightedGraph where W: Comparable & Numeric {

    /// Finds the shortest paths from some route vertex to every other vertex in the graph.
    ///
    /// - parameter graph: The WeightedGraph to look within.
    /// - parameter root: The index of the root node to build the shortest paths from.
    /// - parameter startDistance: The distance to get to the root node (typically 0).
    /// - returns: Returns a tuple of two things: the first, an array containing the distances, the second, a dictionary containing the edge to reach each vertex. Use the function pathDictToPath() to convert the dictionary into something useful for a specific point.
    func dijkstra(root: Int, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
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
    func dijkstra(root: V, startDistance: W) -> ([W?], [Int: WeightedEdge<W>]) {
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
