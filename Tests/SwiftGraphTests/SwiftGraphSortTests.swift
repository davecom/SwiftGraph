//
//  SwiftGraphSearchTests.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2017 David Kopec
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

class SwiftGraphSortTests: XCTestCase {
    // pg 1016 Liang
    let dressDAG: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["undershorts", "socks", "pants", "shoes", "watch", "belt", "shirt", "tie", "jacket"])

    let cyclicGraph: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["A", "B", "C", "D"])

    let noEdgesGraph: _WeightedGraph<String, Int> = _WeightedGraph<String, Int>(nodes: "0", "1")

    let emptyGraph: _WeightedGraph<String, Int> = .init()

    override func setUp() {
        super.setUp()
        // pg 1016 Liang
        dressDAG.edge("undershorts", to: "shoes", directed: true)
        dressDAG.edge("pants", to: "shoes", directed: true)
        dressDAG.edge("socks", to: "shoes", directed: true)
        dressDAG.edge("undershorts", to: "pants", directed: true)
        dressDAG.edge("pants", to: "belt", directed: true)
        dressDAG.edge("belt", to: "jacket", directed: true)
        dressDAG.edge("shirt", to: "tie", directed: true)
        dressDAG.edge("shirt", to: "belt", directed: true)
        dressDAG.edge("tie", to: "jacket", directed: true)
        print(dressDAG)

        // A simple graph with easy cycles.
        cyclicGraph.edge("A", to: "B", directed: true)
        cyclicGraph.edge("B", to: "D", directed: true)
        cyclicGraph.edge("A", to: "D", directed: true)
        cyclicGraph.edge("D", to: "C", directed: true)
        cyclicGraph.edge("C", to: "A", directed: true)
        cyclicGraph.edge("C", to: "B", directed: true)
    }

    func testDAG() {
        XCTAssertTrue(dressDAG.isDAG, "dressDAG is a DAG")
        XCTAssertFalse(cyclicGraph.isDAG, "A cyclic graph is not a DAG.")
    }

    func testToposort() {
        guard let result: [String] = dressDAG.toposort() else {
            XCTFail("dressDAG could not be sorted.")
            return
        }
        print(result)
        XCTAssertEqual(result.count, 9, "All items in sort.")
    }

    func testEmpty() {
        let result1: [Int] = emptyGraph.toposort()!
        XCTAssertTrue(result1.isEmpty, "A graph with no nodes or edges produces an empty sort.")
        XCTAssertFalse(emptyGraph.isDAG, "A graph with no nodes or edges is not a DAG.")

        let result2: [Int] = noEdgesGraph.toposort()!
        XCTAssertTrue(noEdgesGraph.edges.joined().isEmpty, "The graph does not have edges.")
        XCTAssertTrue(result2.isEmpty, "A graph with no edges produces an empty sort.")
        XCTAssertFalse(noEdgesGraph.isDAG, "A graph with no edges is not a DAG.")
    }

    static var allTests = [
        ("testDAG", testDAG),
        ("testToposort", testToposort),
        ("testEmpty", testEmpty),
    ]
}
