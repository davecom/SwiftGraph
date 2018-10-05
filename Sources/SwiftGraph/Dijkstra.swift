//
//  Dijkstra.swift
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

/// `WeightedGraph` extension for doing dijkstra
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
