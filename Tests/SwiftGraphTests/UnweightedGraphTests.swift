//
//  UnweightedGraphTests.swift
//  SwiftGraphTests
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

class UnweightedGraphTests: XCTestCase {

    func testEdgeExists() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertTrue(g.edgeExists(from: "A", to: "B"))
        XCTAssertFalse(g.edgeExists(from: "B", to: "A"))
        XCTAssertFalse(g.edgeExists(from: "A", to: "Y"))
        XCTAssertFalse(g.edgeExists(from: "X", to: "Y"))
    }

    func testPathInitializerUndirected() {
        let g0Path = UnweightedGraph<String>.withPath([])
        XCTAssertEqual(g0Path.vertexCount, 0, "g0Path: Expected empty graph")
        XCTAssertEqual(g0Path.edgeCount, 0, "g0Path: Expected empty graph")

        let g1Path = UnweightedGraph.withPath(["Atlanta"])
        XCTAssertEqual(g1Path.vertices, ["Atlanta"], "g1Path: Expected only Atlanta vertex")
        XCTAssertEqual(g1Path.edgeCount, 0, "g1Path: Expected no edges")

        let g2Path = UnweightedGraph.withPath(["Atlanta", "Boston"])
        XCTAssertEqual(g2Path.vertices, ["Atlanta", "Boston"], "g2Path: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Path.edgeCount, 2, "g2Path: Expected exactly 2 edges")
        XCTAssertTrue(g2Path.edgeExists(from: "Atlanta", to: "Boston"), "g2Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Path.edgeExists(from: "Boston", to: "Atlanta"), "g2Path: Expected an edge from Boston to Atlanta")

        let g3Path = UnweightedGraph.withPath(["Atlanta", "Boston", "Chicago"])
        XCTAssertEqual(g3Path.vertices, ["Atlanta", "Boston", "Chicago"], "g3Path: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Path.edgeCount, 4, "g3Path: Expected exactly 4 edges")
        XCTAssertTrue(g3Path.edgeExists(from: "Atlanta", to: "Boston"), "g3Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Atlanta"), "g3Path: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Chicago"), "g3Path: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Path.edgeExists(from: "Chicago", to: "Boston"), "g3Path: Expected an edge from Chicago to Boston")
    }

    func testPathInitializerDirected() {
        let g0Path = UnweightedGraph<String>.withPath([], directed: true)
        XCTAssertEqual(g0Path.vertexCount, 0, "g0Path: Expected empty graph")
        XCTAssertEqual(g0Path.edgeCount, 0, "g0Path: Expected empty graph")

        let g1Path = UnweightedGraph.withPath(["Atlanta"], directed: true)
        XCTAssertEqual(g1Path.vertices, ["Atlanta"], "g1Path: Expected only Atlanta vertex")
        XCTAssertEqual(g1Path.edgeCount, 0, "g1Path: Expected no edges")

        let g2Path = UnweightedGraph.withPath(["Atlanta", "Boston"], directed: true)
        XCTAssertEqual(g2Path.vertices, ["Atlanta", "Boston"], "g2Path: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Path.edgeCount, 1, "g2Path: Expected exactly 1 edges")
        XCTAssertTrue(g2Path.edgeExists(from: "Atlanta", to: "Boston"), "g2Path: Expected an edge from Atlanta to Boston")

        let g3Path = UnweightedGraph.withPath(["Atlanta", "Boston", "Chicago"], directed: true)
        XCTAssertEqual(g3Path.vertices, ["Atlanta", "Boston", "Chicago"], "g3Path: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Path.edgeCount, 2, "g3Path: Expected exactly 2 edges")
        XCTAssertTrue(g3Path.edgeExists(from: "Atlanta", to: "Boston"), "g3Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Chicago"), "g3Path: Expected an edge from Boston to Chicago")
    }

    func testCycleInitializerUndirected() {
        let g0Cycle = UnweightedGraph<String>.withCycle([])
        XCTAssertEqual(g0Cycle.vertexCount, 0, "g0Cycle: Expected empty graph")
        XCTAssertEqual(g0Cycle.edgeCount, 0, "g0Cycle: Expected empty graph")

        let g1Cycle = UnweightedGraph.withCycle(["Atlanta"])
        XCTAssertEqual(g1Cycle.vertices, ["Atlanta"], "g1Cycle: Expected only Atlanta vertex")
        XCTAssertEqual(g1Cycle.edgeCount, 1, "g1Cycle: Expected 1 edge")
        XCTAssertTrue(g1Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g1Cycle: Expected an edge from Atlanta to Atlanta")

        let g2Cycle = UnweightedGraph.withCycle(["Atlanta", "Boston"])
        XCTAssertEqual(g2Cycle.vertices, ["Atlanta", "Boston"], "g2Cycle: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Cycle.edgeCount, 4, "g2Cycle: Expected exactly 4 edges")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g2Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g2Cycle: Expected an edge from Boston to Atlanta")

        let g3Cycle = UnweightedGraph.withCycle(["Atlanta", "Boston", "Chicago"])
        XCTAssertEqual(g3Cycle.vertices, ["Atlanta", "Boston", "Chicago"], "g3Cycle: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Cycle.edgeCount, 6, "g3Path: Expected exactly 4 edges")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g3Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g3Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Chicago"), "g3Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Boston"), "g3Cycle: Expected an edge from Chicago to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g3Cycle: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Chicago"), "g3Cycle: Expected an edge from Atlanta to Chicago")
    }

    func testCycleInitializerDirected() {
        let g0Cycle = UnweightedGraph<String>.withCycle([], directed: true)
        XCTAssertEqual(g0Cycle.vertexCount, 0, "g0Cycle: Expected empty graph")
        XCTAssertEqual(g0Cycle.edgeCount, 0, "g0Cycle: Expected empty graph")

        let g1Cycle = UnweightedGraph.withCycle(["Atlanta"], directed: true)
        XCTAssertEqual(g1Cycle.vertices, ["Atlanta"], "g1Cycle: Expected only Atlanta vertex")
        XCTAssertEqual(g1Cycle.edgeCount, 1, "g1Cycle: Expected 1 edge")
        XCTAssertTrue(g1Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g1Cycle: Expected an edge from Atlanta to Atlanta")

        let g2Cycle = UnweightedGraph.withCycle(["Atlanta", "Boston"], directed: true)
        XCTAssertEqual(g2Cycle.vertices, ["Atlanta", "Boston"], "g2Cycle: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Cycle.edgeCount, 2, "g2Cycle: Expected exactly 2 edges")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g2Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g2Cycle: Expected an edge from Atlanta to Boston")

        let g3Cycle = UnweightedGraph.withCycle(["Atlanta", "Boston", "Chicago"], directed: true)
        XCTAssertEqual(g3Cycle.vertices, ["Atlanta", "Boston", "Chicago"], "g3Cycle: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Cycle.edgeCount, 3, "g3Cycle: Expected exactly 4 edges")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g3Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Chicago"), "g3Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g3Cycle: Expected an edge from Chicago to Atlanta")
    }
}

