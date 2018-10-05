//
//  BFS.swift
//  SwiftGraph
//
//  Copyright (c) 2018 Ferran Pujol Camins
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

/// A breadth-first search algorithm.
public struct BFS<G: Graph>: GraphTraverser {
    /// Initialize a BFS with the graph to traverse.
    ///
    /// - Parameter graph: The graph that will be traversed by the algorithm.
    public init(on graph: G) {
        self.graph = graph
    }

    /// Construct a version of the BFS algorithm that can guarantee a certain order of traversal
    /// for the neighbours of each visited vertex.
    ///
    /// The constructed algorithm is slower than BFS.
    ///
    /// - Parameter visitOrder: A closure that orders an array of edges.
    ///                         The input parameter is an array with the edges outgoing from the
    ///                         currently visited vertex.
    ///                         The return value is an array with the same edges of the input array,
    ///                         but sorted in the order that they will be visited.
    /// - Returns: A new version of the algorithm with the specified visit order.
    public func withVisitOrder(_ visitOrder: @escaping G.VisitOrder) -> BFSVisitOrder<G> {
        return BFSVisitOrder<G>(on: self.graph, withVisitOrder: visitOrder)
    }

    public let graph: G

    public func from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int? {
        // Setup

        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }

        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container = Queue<E>()

        // Traversal

        visited[initalVertexIndex] = true
        let neighbours = graph.edgesForIndex(initalVertexIndex)
        for e in neighbours {
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
                let neighbours = graph.edgesForIndex(v)
                for e in neighbours {
                    if !visited[e.v] {
                        container.push(e)
                        visited[e.v] = true
                    }
                }
            }
        }
        return nil // no route found
    }
}

/// A breadth-first search algorithm that can guarantee a certain order of traversal
/// for the neighbours of each visited vertex.
///
/// Even if the provided visitOrder is a no-operation closure, this algorithm is slower than BFS.
public struct BFSVisitOrder<G: Graph>: GraphTraverser {
    /// Initialize a BFS with the graph to traverse.
    ///
    /// - Parameter graph: The graph that will be traversed by the algorithm.
    public init(on graph: G) {
        self.graph = graph
    }

    /// Initialize a BFS with the graph to traverse and a visit order.
    ///
    /// - Parameters:
    ///   - graph: The graph that will be traversed by the algorithm.
    ///   - visitOrder: A closure that orders an array of edges.
    ///                 The input parameter is an array with the edges outgoing from the
    ///                 currently visited vertex.
    ///                 The return value is an array with the same edges of the input array,
    ///                 but sorted in the order that they will be visited.
    public init(on graph: G, withVisitOrder visitOrder: @escaping G.VisitOrder) {
        self.graph = graph
        self.visitOrder = visitOrder
    }

    public let graph: G
    private var visitOrder: G.VisitOrder = { $0 }

    public func from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int? {
        // Setup

        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }

        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container = Queue<E>()

        // Traversal

        visited[initalVertexIndex] = true
        let neighbours = visitOrder(graph.edgesForIndex(initalVertexIndex))
        for i in 0..<neighbours.count {
            let e = neighbours[i]
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
                let neighbours = visitOrder(graph.edgesForIndex(v))
                for i in 0..<neighbours.count {
                    let e = neighbours[i]
                    if !visited[e.v] {
                        container.push(e)
                        visited[e.v] = true
                    }
                }
            }
        }
        return nil // no route found
    }
}

// MARK: Breadth-First Search Extensions to `Graph`
//       These are convenience methods that construct the appropiate BFS object for self
public extension Graph {

    public func bfs(fromIndex: Int, goalTest: (Int) -> Bool) -> [E] {
        return BFS(on: self).from(index: fromIndex, goalTest: goalTest)
    }

    public func bfs(from: V, goalTest: (V) -> Bool) -> [E] {
        return BFS(on: self).from(from, goalTest: goalTest)
    }


    public func bfs(fromIndex: Int, toIndex: Int) -> [E] {
        return BFS(on: self).from(index: fromIndex, toIndex: toIndex)
    }

    public func bfs(from: V, to: V) -> [E] {
        return BFS(on: self).from(from, to: to)
    }

    public func visitBfs(fromIndex: Int, executing closure: @escaping (Int)->(Bool)) {
        BFS(on: self).visit(fromIndex: fromIndex, executing: closure)
    }

    public func visitBfs(from: V, executing closure: @escaping (V)->(Bool)) {
        BFS(on: self).visit(from: from, executing: closure)
    }

    public func findAllBFS(fromIndex: Int, goalTest: @escaping (Int) -> Bool) -> [[E]] {
        return BFS(on: self).findAll(fromIndex: fromIndex, goalTest: goalTest)
    }

    public func findAllBFS(from: V, goalTest: @escaping (V) -> Bool) -> [[E]] {
        return BFS(on: self).findAll(from: from, goalTest: goalTest)
    }
}
