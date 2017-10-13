//
//  CycleTests.swift
//  SwiftGraph
//
//  Copyright (c) 2017 David Kopec
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
@testable import SwiftGraph

class CycleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFullyConnected() {
        // setup a graph with 5 fully connected vertices
        let testVertices = ["A", "B", "C", "D", "E"]
        let fullyConnected: UnweightedGraph<String> = UnweightedGraph<String>(vertices: testVertices)
        for from in 0..<testVertices.count {
            for to in (from + 1)..<testVertices.count {
                fullyConnected.addEdge(from: from, to: to)
            }
        }
        // check it has 84 cycles
        let cycles = fullyConnected.detectCycles()
        XCTAssertEqual(cycles.count, 84, "Should be 84 cycles in a fully connected 5 vertex graph.")
    }
    
    func testDetectCycles1() {
        // simple graph with easy known cycles
        let simpleGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["A", "B", "C", "D"])
        simpleGraph.addEdge(from: "A", to: "B", directed: true)
        simpleGraph.addEdge(from: "B", to: "D", directed: true)
        simpleGraph.addEdge(from: "A", to: "D", directed: true)
        simpleGraph.addEdge(from: "D", to: "C", directed: true)
        simpleGraph.addEdge(from: "C", to: "A", directed: true)
        simpleGraph.addEdge(from: "C", to: "B", directed: true)

        let solutionVertexCycles = [["A", "B", "D", "C", "A"], ["A", "D", "C", "A"], ["B", "D", "C", "B"]]
        let solutionEdgeCycles: [[(Int, Int)]] = [
            [(0, 1), (1, 3), (3, 2), (2, 0)],
            [(0, 3), (3, 2), (2, 0)],
            [(1, 3), (3, 2), (2, 1)],
        ]

        let detectedVertexCycles = simpleGraph.detectCycles()
        let detectedEdgeCycles = simpleGraph.detectCyclesOfEdges()

        XCTAssertEqual(detectedVertexCycles.count, solutionVertexCycles.count)
        XCTAssertTrue(detectedVertexCycles[0].elementsEqual(solutionVertexCycles[1]))
        XCTAssertTrue(detectedVertexCycles[1].elementsEqual(solutionVertexCycles[2]))
        XCTAssertTrue(detectedVertexCycles[2].elementsEqual(solutionVertexCycles[0]))

        print(detectedEdgeCycles)

        XCTAssertEqual(detectedEdgeCycles.count, solutionEdgeCycles.count)
        assertArraysOfTuplesEqual(detectedEdgeCycles[0].map { edge in (edge.u, edge.v) }, solutionEdgeCycles[1])
        assertArraysOfTuplesEqual(detectedEdgeCycles[1].map { edge in (edge.u, edge.v) }, solutionEdgeCycles[2])
        assertArraysOfTuplesEqual(detectedEdgeCycles[2].map { edge in (edge.u, edge.v) }, solutionEdgeCycles[0])
    }

    func assertArraysOfTuplesEqual(_ lhs: [(Int, Int)], _ rhs: [(Int, Int)], line: UInt = #line) {
        let elementsEqual = lhs.elementsEqual(rhs) { (left, right) -> Bool in left.0 == right.0 && left.1 == right.1 }
        if !elementsEqual {
            XCTFail("Arrays not equal: \(lhs), \(rhs)", line: line)
        }
    }
    
    static var allTests = [
        ("testFullyConnected", testFullyConnected),
        ("testDetectCycles1", testDetectCycles1)
    ]
}
