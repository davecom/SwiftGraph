//: Playground - noun: a place where people can play

import Foundation
import SwiftGraph

var graph = WeightedGraph<String, Int>(vertices: ["A", "B", "C", "D", "E"])

graph.addEdge(from: "A", to: "B", directed: true, weight: 1)
graph.addEdge(from: "B", to: "E", directed: true, weight: 1)
graph.addEdge(from: "C", to: "D", directed: true, weight: 1)
graph.addEdge(from: "A", to: "D", directed: true, weight: 4)
graph.addEdge(from: "D", to: "E", directed: true, weight: 2)
graph.addEdge(from: "A", to: "C", directed: true, weight: 1)

graph.isAcyclic()

graph.topologicallySortedIndices()
graph.topologicallySortedVertices()
