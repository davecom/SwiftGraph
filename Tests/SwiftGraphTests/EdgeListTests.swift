//
//  UnionTests.swift
//  SwiftGraph
//
//  Copyright (c) 2019 Ferran Pujol Camins
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

import XCTest
import SwiftGraph

class EdgeListTests: XCTestCase {

    func testSingleDirectedEdgeList() {
        let g = UnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertEqual(g.edgeList(), [UnweightedEdge(u: 0, v: 1, directed: true)])
    }

    func testSingleDirectedLoopList() {
        let g = UnweightedGraph(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        XCTAssertEqual(g.edgeList(), [UnweightedEdge(u: 0, v: 0, directed: true)])
    }

    func testSingleUndirectedEdgeList() {
        let g = UnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.edgeList(), [UnweightedEdge(u: 0, v: 1, directed: false)])
    }

    func testSingleUndirectedLoopList() {
        let g = UnweightedGraph(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.edgeList(), [UnweightedEdge(u: 0, v: 0, directed: false)])
    }

    func testDirectedAndUndirectedEdges() {
        let g = UnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 0, v: 1, directed: false)
        ])
    }

    func testDirectedAndUndirectedLoops() {
        let g = UnweightedGraph(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 0, directed: true),
            UnweightedEdge(u: 0, v: 0, directed: false)
        ])
    }

    func testTwoDirectedEdges() {
        let g = UnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 0, v: 1, directed: true)
        ])

        let g2 = UnweightedGraph(vertices: ["A", "B"])
        g2.addEdge(from: "A", to: "B", directed: true)
        g2.addEdge(from: "B", to: "A", directed: true)
        XCTAssertEqual(g2.edgeList(), [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 1, v: 0, directed: true)
        ])
    }

    func testTwoDirectedLoops() {
        let g = UnweightedGraph(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        g.addEdge(from: "A", to: "A", directed: true)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 0, directed: true),
            UnweightedEdge(u: 0, v: 0, directed: true)
        ])
    }

    func testTwoUndirectedEdges() {
        let g = UnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 0, v: 1, directed: false)
        ])
    }

    func testTwoUndirectedLoops() {
        let g = UnweightedGraph(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: false)
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.edgeList(), [
            UnweightedEdge(u: 0, v: 0, directed: false),
            UnweightedEdge(u: 0, v: 0, directed: false)
        ])
    }

    func testCompleteGraph() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C", "D"])
        XCTAssertEqual(g.edgeList().count, 6)
    }
}
