//
//  WeightedUniqueElementsGraphTests.swift
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

import XCTest
@testable import SwiftGraph

class WeightedUniqueElementsGraphTests: XCTestCase {

    func testUniqueVertexAfterInit() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Atlanta"])
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }

    func testUniqueVertexAfterAddition() {
        let g = WeightedUniqueElementsGraph<String, String>()
        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")

        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }
    
    func testUniqueUndirectedEdgesSameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueUndirectedEdgesDifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC2", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC2"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC2"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 4, "Expected four edges")
    }

    func testUniqueUndirectedEdges2() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Boston", "Chicago"])
        g.addEdge(from: "Chicago", to: "Boston", weight: "CB", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Boston", withWeight: "CB"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Boston", to: "Chicago", withWeight: "CB"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Chicago", to: "Boston", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "Boston", to: "Chicago", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertFalse(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 4, "Expected four edges")
    }

    func testUniqueUndirectedLoopSameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expect one edge")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertEqual(g.edgeCount, 1, "Expected one edge")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
    }

    func testUniqueUndirectedLoopDifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expect one edge")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA2", directed: false)
        XCTAssertEqual(g.edgeCount, 2, "Expected two edge")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA2"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
    }

    func testUniqueUndirectedLoop2SameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", weight: "AB", directed: false)
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 3, "Expected three edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertEqual(g.edgeCount, 3, "Expected three edges")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
    }

    func testUniqueUndirectedLoop2DifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", weight: "AB", directed: false)
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 3, "Expected three edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA2", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA2"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 4, "Expected three edges")
    }

    func testUniqueDirectedEdgesSameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: true)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")
    }

    func testUniqueDirectedEdgesDifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: true)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC2", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC2"), "Expected an edge from Atlanta to Chicago")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")
    }

    func testUniqueDirectedLoopSameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")
    }

    func testUniqueDirectedLoopDifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA2", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA2"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")
    }

    func testUniqueDirectedLoop2SameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", weight: "AB", directed: true)
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")
    }

    func testUniqueDirectedLoop2DifferentWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", weight: "AB", directed: true)
        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", weight: "AA2", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "AA2"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Atlanta", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 3, "Expected one edges")
    }
    
    func testUniqueEdgesCombinedSameWeight() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueEdgesCombinedDifferentWeight1() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC2", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC2"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 3, "Expected two edges")
    }

    func testUniqueEdgesCombinedDifferentWeight2() {
        let g = WeightedUniqueElementsGraph<String, String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC2", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", weight: "AC", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC2"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta", withWeight: "AC2"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "AC"), "Expected an edge from Chicago to Atlanta")
        XCTAssertFalse(g.edgeExists(from: "Atlanta", to: "Chicago", withWeight: "X"))
        XCTAssertEqual(g.edgeCount, 3, "Expected two edges")
    }
}
