//
//  WeightedGraphTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 05/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class WeightedGraphTests: XCTestCase {

    func testEdgeExists() {
        let g = WeightedGraph<String, String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        XCTAssertTrue(g.edgeExists(from: "A", to: "B"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A"))
        XCTAssertTrue(g.edgeExists(from: "A", to: "B", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "A", to: "Y", withWeight: "AB"))
        XCTAssertFalse(g.edgeExists(from: "X", to: "Y", withWeight: "AB"))
    }

    func testWeights() {
        let g = WeightedGraph<String, String>(
            vertices: ["A", "B", "C"]
        )
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)
        g.addEdge(from: "A", to: "B", weight: "AB2", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)

        XCTAssertEqual(g.edgeCount, 4, "Wrong number of edges.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "A", to: "B"),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the graph.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "C"),
            ["BC", "BC"]
        ), "Duplicated edge 'BC' must appear twice.")
    }
}
