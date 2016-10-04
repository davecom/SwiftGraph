//: Playground - noun: a place where people can play

import Foundation
import SwiftGraph

var graph = WeightedGraph<String, Int>(vertices: ["A", "B", "C", "D", "E"])

graph.addEdge(from: "A", to: "B", directed: true, weight: 1)
graph.addEdge(from: "B", to: "C", directed: true, weight: 1)
graph.addEdge(from: "C", to: "D", directed: true, weight: 1)
graph.addEdge(from: "A", to: "D", directed: true, weight: 4)

graph.edgesForVertex("A")

let (distances, pathDict) = dijkstra(graph: graph,
                                     root: "A",
                                     startDistance: 0)

let result = distanceArrayToVertexDict(distances: distances,
                                       graph: graph)

result["D"]

graph.neighborsForVertex("D")

graph.depthFirstSearch(from: 0, to: 3)

