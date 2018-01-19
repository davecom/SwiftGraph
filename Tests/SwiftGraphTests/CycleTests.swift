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

@testable import SwiftGraph
import XCTest

class CycleTests: XCTestCase {
    var simpleGraph: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["A", "B", "C", "D"])
    var fullyConnected: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["A", "B", "C", "D", "E"])

    override func setUp() {
        super.setUp()

        // setup a graph with 5 fully connected nodes
        for from in 0 ..< fullyConnected.nodeCount {
            for to in (from + 1) ..< fullyConnected.nodeCount {
                fullyConnected.edge(from, to: to)
            }
        }

        // simple graph with easy known cycles
        simpleGraph.edge("A", to: "B", directed: true)
        simpleGraph.edge("B", to: "D", directed: true)
        simpleGraph.edge("A", to: "D", directed: true)
        simpleGraph.edge("D", to: "C", directed: true)
        simpleGraph.edge("C", to: "A", directed: true)
        simpleGraph.edge("C", to: "B", directed: true)
    }

    func testFullyConnectedNodes() {
        // check it has 84 cycles
        let cycles: [[String]] = fullyConnected.cycles()
        XCTAssertEqual(cycles.count, 84, "Should be 84 cycles in a fully connected 5 node graph.")
    }

    func testFullyConnectedEdges() {
        // check it has 84 cycles
        let cycles: [[_UnweightedEdge]] = fullyConnected.cycles()
        XCTAssertEqual(cycles.count, 84, "Should be 84 cycles in a fully connected 5 node graph.")
    }

    func testDetectCyclesNodes1() {

        let solutionNodeCycles = [["A", "B", "D", "C", "A"], ["A", "D", "C", "A"], ["B", "D", "C", "B"]]

        let detectedNodeCycles: [[String]] = simpleGraph.cycles()

        XCTAssertEqual(detectedNodeCycles.count, solutionNodeCycles.count)
        XCTAssertTrue(detectedNodeCycles[0].elementsEqual(solutionNodeCycles[1]))
        XCTAssertTrue(detectedNodeCycles[1].elementsEqual(solutionNodeCycles[2]))
        XCTAssertTrue(detectedNodeCycles[2].elementsEqual(solutionNodeCycles[0]))
    }

    func testDetectCyclesEdges1() {
        let solutionEdgeCycles: [[(Int, Int)]] = [
            [(0, 1), (1, 3), (3, 2), (2, 0)],
            [(0, 3), (3, 2), (2, 0)],
            [(1, 3), (3, 2), (2, 1)],
        ]

        let detectedEdgeCycles: [[_UnweightedEdge]] = simpleGraph.cycles()

        print(detectedEdgeCycles)

        XCTAssertEqual(detectedEdgeCycles.count, solutionEdgeCycles.count)
        assertArraysOfTuplesEqual(detectedEdgeCycles[0].map { edge in edge.asTuple }, solutionEdgeCycles[1])
        assertArraysOfTuplesEqual(detectedEdgeCycles[1].map { edge in edge.asTuple }, solutionEdgeCycles[2])
        assertArraysOfTuplesEqual(detectedEdgeCycles[2].map { edge in edge.asTuple }, solutionEdgeCycles[0])
    }

    func testLimit() {
        let cyclesEdges: [[_UnweightedEdge]] = fullyConnected.cycles(until: 2)
        let cyclesNodes: [[String]] = fullyConnected.cycles(until: 2)
        XCTAssertEqual(cyclesEdges.count, 30, "Should be 30 cycles instead of 84.")
        XCTAssertEqual(cyclesNodes.count, 10, "Should be 10 cycles instead of 84.")
    }

    func assertArraysOfTuplesEqual(_ lhs: [(Int, Int)], _ rhs: [(Int, Int)], line: UInt = #line) {
        let elementsEqual = lhs.elementsEqual(rhs) { left, right -> Bool in left.0 == right.0 && left.1 == right.1 }
        if !elementsEqual {
            XCTFail("Arrays not equal: \(lhs), \(rhs)", line: line)
        }
    }

    static var allTests = [
        ("testFullyConnectedNodes", testFullyConnectedNodes),
        ("testFullyConnectedEdges", testFullyConnectedEdges),
        ("testDetectCyclesNodes1", testDetectCyclesNodes1),
        ("testDetectCyclesEdges1", testDetectCyclesEdges1),
        ("testLimit", testLimit),
    ]
}

fileprivate extension Edge {
    var asTuple: (Int, Int) {
        return (source, target)
    }
}
