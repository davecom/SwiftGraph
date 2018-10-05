//
//  GraphTraverser.swift
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

extension Graph {
    public typealias VisitOrder = ([E]) -> [E]
    public typealias Reducer = (E)->Bool
}

/// An algorithm to traverse the vertices of a graph.
protocol GraphTraverser {

    /// The type of the graph to traverse
    associatedtype G: Graph

    typealias V = G.V
    typealias E = G.E

    /// The graph to traverse
    var graph: G { get }

    /// Traverse the graph from an initial vertex to the first vertex that satisfies a goal test.
    ///
    /// - Parameters:
    ///   - initalVertexIndex: The index of the initial vertex
    ///   - goalTest: Returns true if a given vertex index is a goal. When this closure returns true
    ///               The algorithm stops traversing the graph when this closure returns true.
    ///   - reducer: A reducer that is fed with each visited vertex. The input parameter
    ///              is the edge from the previous vertex to the visited vertex.
    ///              If the return value is false, the neighbours of the input vertex will not be visited.
    /// - Returns: The index of the first vertex found to satisfy goalTest or nil if no vertex is found.
    func from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int?
}

extension GraphTraverser {

    /// Find a route from an initial vertex to the first vertex that satisfies a goal test.
    ///
    /// - parameter index: The index of the initial vertex.
    /// - parameter goalTest: Returns true if a given vertex index is a goal.
    ///                       The algorithm stops traversing the graph when this closure returns true.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found.
    public func from(index: Int, goalTest: (Int) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var pathDict:[Int: E] = [:]
        let result = from(index, goalTest: goalTest, reducer: { (e: E) -> Bool in
            pathDict[e.v] = e
            return true
        })
        if let vertexFound = result {
            return pathDictToPath(from: index, to: vertexFound, pathDict: pathDict) as! [E]
        }
        return []
    }

    /// Find a route from an initial vertex to the first vertex that satisfies a goal test.
    ///
    /// - parameter initalVertex: The initial vertex.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    ///                       The algorithm stops traversing the graph when this closure returns true.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found.
    public func from(_ initalVertex: V, goalTest: (V) -> Bool) -> [E] {
        if let u = graph.indexOfVertex(initalVertex) {
            return from(index: u, goalTest: { goalTest(graph.vertexAtIndex($0)) })
        }
        return []
    }

    /// Find a route from an initial vertex to the first vertex that satisfies a goal test.
    ///
    /// - parameter index: The index of the initial vertex.
    /// - parameter toIndex: The index of the target vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found.
    public func from(index: Int, toIndex: Int) -> [E] {
        return from(index: index, goalTest: { $0 == toIndex })
    }

    /// Find a route from an initial vertex to the first vertex that satisfies a goal test.
    ///
    /// - parameter from: The initiaal vertex.
    /// - parameter to: The target vertex.
    /// - returns: An array of Edges containing the entire route, or an empty array if no route could be found.
    public func from(_ initalVertex: V, to: V) -> [E] {
        if let u = graph.indexOfVertex(initalVertex) {
            if let v = graph.indexOfVertex(to) {
                return from(index: u, toIndex: v)
            }
        }
        return []
    }

    /// Visit all reachable vertices from the initial vertex and execute a closure on each visited vertex.
    ///
    /// - Parameters:
    ///   - index: The index of the initial vertex.
    ///   - closure: The closure to execute on each visited vertex. Takes the index of
    ///              the visited vertex as input parameter.
    ///              If the return value is false, the neighbours of the vertex are not visited.
    public func visit(fromIndex index: Int, executing closure: @escaping (Int)->(Bool)) {
        if closure(index) {
            _ = from(index, goalTest: { _ in false }, reducer: { closure($0.v) })
        }
    }

    /// Visit all reachable vertices from the initial vertex and execute a closure on each visited vertex.
    ///
    /// - Parameters:
    ///   - initialVertex: The vertex where to start the traversal.
    ///   - closure: The closure to execute on each visited vertex.
    ///              Takes the visited vertex as input parameter.
    ///              If the return value is false, the neighbours of the vertex are not visited.
    public func visit(from initialVertex: V, executing closure: @escaping (V)->(Bool)) {
        guard let v = graph.indexOfVertex(initialVertex) else { return }
        visit(fromIndex: v, executing: { closure(self.graph.vertexAtIndex($0))})
    }

    /// Find path routes from an initial vertex to all the vertices satisfying a goal test.
    ///
    /// - parameter fromIndex: The index of the starting vertex.
    /// - parameter goalTest: Returns true if a given vertex index is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(),
    ////           or an empty array if no routes could be found.
    public func findAll(fromIndex: Int, goalTest: @escaping (Int) -> Bool) -> [[E]] {

        var pathDict: [Int: Edge] = [Int: Edge]()
        var paths: [[Edge]] = [[Edge]]()

        visit(fromIndex: fromIndex) { (v) -> (Bool) in
            if goalTest(v) {
                // figure out route of edges based on pathDict
                paths.append(pathDictToPath(from: fromIndex, to: v, pathDict: pathDict))
            }

            for e in self.graph.edgesForIndex(v) {
                if pathDict[e.v] == nil {
                    pathDict[e.v] = e
                }
            }
            return true
        }
        return paths as! [[Self.E]]
    }

    /// Find path routes from an initial vertex to all the vertices satisfying a goal test.
    ///
    /// - parameter from: The vertex where to start the traversal.
    /// - parameter goalTest: Returns true if a given vertex is a goal.
    /// - returns: An array of arrays of Edges containing routes to every vertex connected and passing goalTest(),
    ////           or an empty array if no routes could be found.
    public func findAll(from: V, goalTest: @escaping (V) -> Bool) -> [[E]] {
        guard let index = graph.indexOfVertex(from) else { return [] }
        return findAll(fromIndex: index, goalTest: { goalTest(self.graph.vertexAtIndex($0)) })
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
