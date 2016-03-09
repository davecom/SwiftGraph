//
//  Search.swift
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

/// Functions for searching a graph & utility functions for supporting them

/// Find a route from one vertex to another using a depth first search.
///
/// - parameter from: The index of the starting vertex.
/// - parameter to: The index of the ending vertex.
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
/// - parameter from: The starting vertex.
/// - parameter to: The ending vertex.
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
/// - parameter from: The index of the starting vertex.
/// - parameter to: The index of the ending vertex.
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
/// - parameter from: The starting vertex.
/// - parameter to: The ending vertex.
/// - returns: An array of Edges containing the entire route, or an empty array if no route could be found
public func bfs<T: Equatable>(from: T, to: T, graph: Graph<T>) -> [Edge] {
    if let u = graph.indexOfVertex(from) {
        if let v = graph.indexOfVertex(to) {
            return bfs(u, to: v, graph: graph)
        }
    }
    return []
}

/// Finds the shortest paths from some route vertex to every other vertex in the graph. Note this doesn't yet use a priority queue, so it is very slow.
///
/// - paramseter graph: The WeightedGraph to look within.
/// - parameter root: The index of the root node to build the shortest paths from.
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


/// A convenience version of dijkstra() that allows the supply of root vertice 
/// instead of the index of the root vertice.
public func dijkstra<T: Equatable, W: protocol<Comparable, Summable>> (graph: WeightedGraph<T, W>, root: T) -> ([W?], [Int: WeightedEdge<W>]) {
    if let u = graph.indexOfVertex(root) {
        return dijkstra(graph, root: u)
    }
    return ([], [:])
}

/// Helper function to get easier access to Dijkstra results.
public func distanceArrayToVertexDict<T: Equatable, W: protocol<Comparable, Summable>>(distances: [W?], graph: WeightedGraph<T, W>) -> [T : W?] {
    var distanceDict: [T: W?] = [T: W?]()
    for i in 0..<distances.count {
        distanceDict[graph.vertexAtIndex(i)] = distances[i]
    }
    return distanceDict
}

/// Utility function that takes an array of Edges and converts it to an ordered list of vertices
///
/// - parameter edges: Array of edges to convert.
/// - parameter graph: The graph the edges exist within.
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