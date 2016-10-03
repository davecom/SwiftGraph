//: Playground - noun: a place where people can play

import Foundation
import SwiftGraph

var graph = WeightedGraph<String, Int>(vertices: ["A", "B", "C", "D"])

graph.addEdge(from: "A", to: "B", weight: 1)
graph.addEdge(from: "B", to: "C", weight: 1)
graph.addEdge(from: "C", to: "D", weight: 1)
graph.addEdge(from: "A", to: "D", weight: 4)

graph.edgesForVertex("A")

let (distances, pathDict) = dijkstra(graph: graph,
                                     root: "A",
                                     startDistance: 0)

let result = distanceArrayToVertexDict(distances: distances,
                                       graph: graph)

result["D"]
