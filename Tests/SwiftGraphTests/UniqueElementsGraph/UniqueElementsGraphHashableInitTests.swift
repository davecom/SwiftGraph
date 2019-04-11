//
//  UnweightedUniqueElementsGraphHashableInitTests.swift
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

class UnweightedUniqueElementsGraphHashableInitTests: XCTestCase {

    func testPathInitializerUndirected() {
        let g0Path = UnweightedUniqueElementsGraph<String>.withPath([])
        XCTAssertEqual(g0Path.vertexCount, 0, "g0Path: Expected empty graph")
        XCTAssertEqual(g0Path.edgeCount, 0, "g0Path: Expected empty graph")

        let g1Path = UnweightedUniqueElementsGraph.withPath(["Atlanta"])
        XCTAssertEqual(g1Path.vertices, ["Atlanta"], "g1Path: Expected only Atlanta vertex")
        XCTAssertEqual(g1Path.edgeCount, 0, "g1Path: Expected no edges")

        let g2Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston"])
        XCTAssertEqual(g2Path.vertices, ["Atlanta", "Boston"], "g2Path: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Path.edgeCount, 2, "g2Path: Expected exactly 2 edges")
        XCTAssertTrue(g2Path.edgeExists(from: "Atlanta", to: "Boston"), "g2Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Path.edgeExists(from: "Boston", to: "Atlanta"), "g2Path: Expected an edge from Boston to Atlanta")

        let g3Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Chicago"])
        XCTAssertEqual(g3Path.vertices, ["Atlanta", "Boston", "Chicago"], "g3Path: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Path.edgeCount, 4, "g3Path: Expected exactly 4 edges")
        XCTAssertTrue(g3Path.edgeExists(from: "Atlanta", to: "Boston"), "g3Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Atlanta"), "g3Path: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Chicago"), "g3Path: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Path.edgeExists(from: "Chicago", to: "Boston"), "g3Path: Expected an edge from Chicago to Boston")

        let g4Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Atlanta"])
        XCTAssertEqual(g4Path.vertices, ["Atlanta", "Boston"], "g4Path: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g4Path.edgeCount, 2, "g4Path: Expected exactly 2 edges")
        XCTAssertTrue(g4Path.edgeExists(from: "Atlanta", to: "Boston"), "g4Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g4Path.edgeExists(from: "Boston", to: "Atlanta"), "g4Path: Expected an edge from Boston to Atlanta")

        let g5Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Chicago", "Atlanta", "Denver", "Chicago", "Atlanta"])
        XCTAssertEqual(g5Path.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "g5Path: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g5Path.edgeCount, 10, "g5Path: Expected exactly 10 edges")
        XCTAssertTrue(g5Path.edgeExists(from: "Atlanta", to: "Boston"), "g5Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g5Path.edgeExists(from: "Boston", to: "Atlanta"), "g5Path: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g5Path.edgeExists(from: "Boston", to: "Chicago"), "g5Path: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g5Path.edgeExists(from: "Chicago", to: "Boston"), "g5Path: Expected an edge from Chicago to Boston")
        XCTAssertTrue(g5Path.edgeExists(from: "Chicago", to: "Atlanta"), "g5Path: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g5Path.edgeExists(from: "Atlanta", to: "Chicago"), "g5Path: Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g5Path.edgeExists(from: "Atlanta", to: "Denver"), "g5Path: Expected an edge from Atlanta to Denver")
        XCTAssertTrue(g5Path.edgeExists(from: "Denver", to: "Atlanta"), "g5Path: Expected an edge from Denver to Atlanta")
        XCTAssertTrue(g5Path.edgeExists(from: "Denver", to: "Chicago"), "g5Path: Expected an edge from Denver to Chicago")
        XCTAssertTrue(g5Path.edgeExists(from: "Chicago", to: "Denver"), "g5Path: Expected an edge from Chicago to Denver")
    }

    func testPathInitializerDirected() {
        let g0Path = UnweightedUniqueElementsGraph<String>.withPath([], directed: true)
        XCTAssertEqual(g0Path.vertexCount, 0, "g0Path: Expected empty graph")
        XCTAssertEqual(g0Path.edgeCount, 0, "g0Path: Expected empty graph")

        let g1Path = UnweightedUniqueElementsGraph.withPath(["Atlanta"], directed: true)
        XCTAssertEqual(g1Path.vertices, ["Atlanta"], "g1Path: Expected only Atlanta vertex")
        XCTAssertEqual(g1Path.edgeCount, 0, "g1Path: Expected no edges")

        let g2Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston"], directed: true)
        XCTAssertEqual(g2Path.vertices, ["Atlanta", "Boston"], "g2Path: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Path.edgeCount, 1, "g2Path: Expected exactly 1 edges")
        XCTAssertTrue(g2Path.edgeExists(from: "Atlanta", to: "Boston"), "g2Path: Expected an edge from Atlanta to Boston")

        let g3Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Chicago"], directed: true)
        XCTAssertEqual(g3Path.vertices, ["Atlanta", "Boston", "Chicago"], "g3Path: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Path.edgeCount, 2, "g3Path: Expected exactly 2 edges")
        XCTAssertTrue(g3Path.edgeExists(from: "Atlanta", to: "Boston"), "g3Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Path.edgeExists(from: "Boston", to: "Chicago"), "g3Path: Expected an edge from Boston to Chicago")

        let g4Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Atlanta"], directed: true)
        XCTAssertEqual(g4Path.vertices, ["Atlanta", "Boston"], "g4Path: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g4Path.edgeCount, 2, "g4Path: Expected exactly 2 edges")
        XCTAssertTrue(g4Path.edgeExists(from: "Atlanta", to: "Boston"), "g4Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g4Path.edgeExists(from: "Boston", to: "Atlanta"), "g4Path: Expected an edge from Boston to Atlanta")

        let g5Path = UnweightedUniqueElementsGraph.withPath(["Atlanta", "Boston", "Chicago", "Atlanta", "Denver", "Chicago", "Atlanta"], directed: true)
        XCTAssertEqual(g5Path.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "g4Path: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g5Path.edgeCount, 5, "g5Path: Expected exactly 5 edges")
        XCTAssertTrue(g5Path.edgeExists(from: "Atlanta", to: "Boston"), "g5Path: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g5Path.edgeExists(from: "Boston", to: "Chicago"), "g5Path: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g5Path.edgeExists(from: "Chicago", to: "Atlanta"), "g5Path: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g5Path.edgeExists(from: "Atlanta", to: "Denver"), "g5Path: Expected an edge from Atlanta to Denver")
        XCTAssertTrue(g5Path.edgeExists(from: "Denver", to: "Chicago"), "g5Path: Expected an edge from Denver to Chicago")
    }

    func testCycleInitializerUndirected() {
        let g0Cycle = UnweightedUniqueElementsGraph<String>.withCycle([])
        XCTAssertEqual(g0Cycle.vertexCount, 0, "g0Cycle: Expected empty graph")
        XCTAssertEqual(g0Cycle.edgeCount, 0, "g0Cycle: Expected empty graph")

        let g1Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta"])
        XCTAssertEqual(g1Cycle.vertices, ["Atlanta"], "g1Cycle: Expected only Atlanta vertex")
        XCTAssertEqual(g1Cycle.edgeCount, 1, "g1Cycle: Expected 1 edges")
        XCTAssertTrue(g1Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g1Cycle: Expected an edge from Atlanta to Atlanta")

        let g2Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston"])
        XCTAssertEqual(g2Cycle.vertices, ["Atlanta", "Boston"], "g2Cycle: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Cycle.edgeCount, 2, "g2Cycle: Expected exactly 2 edges")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g2Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g2Cycle: Expected an edge from Boston to Atlanta")

        let g3Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago"])
        XCTAssertEqual(g3Cycle.vertices, ["Atlanta", "Boston", "Chicago"], "g3Cycle: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Cycle.edgeCount, 6, "g3Path: Expected exactly 6 edges")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g3Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g3Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Chicago"), "g3Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Boston"), "g3Cycle: Expected an edge from Chicago to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g3Cycle: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Chicago"), "g3Cycle: Expected an edge from Atlanta to Chicago")

        let g4Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Atlanta"])
        XCTAssertEqual(g4Cycle.vertices, ["Atlanta", "Boston"], "g4Cycle: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g4Cycle.edgeCount, 3, "g4Cycle: Expected exactly 3 edges")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g4Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g4Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g4Cycle: Expected an edge from Atlanta to Boston")

        let g5Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago", "Atlanta", "Denver", "Chicago", "Atlanta"])
        XCTAssertEqual(g5Cycle.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "g5Cycle: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g5Cycle.edgeCount, 11, "g5Path: Expected exactly 11 edges")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g5Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g5Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Boston", to: "Chicago"), "g5Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Chicago", to: "Boston"), "g5Cycle: Expected an edge from Chicago to Boston")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g5Cycle: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Chicago"), "g5Cycle: Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Denver"), "g5Cycle: Expected an edge from Atlanta to Denver")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Denver", to: "Atlanta"), "g5Cycle: Expected an edge from Denver to Atlanta")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Denver", to: "Chicago"), "g5Cycle: Expected an edge from Denver to Chicago")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Chicago", to: "Denver"), "g5Cycle: Expected an edge from Chicago to Denver")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g5Cycle: Expected an edge from Atlanta to Boston")

        let g6Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago", "Denver", "Boston", "Eugene"])
        XCTAssertEqual(g6Cycle.vertices, ["Atlanta", "Boston", "Chicago", "Denver", "Eugene"], "g6Cycle: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g6Cycle.edgeCount, 12, "g6Cycle: Expected exactly 12 edges")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g6Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g6Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Chicago"), "g6Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Chicago", to: "Boston"), "g6Cycle: Expected an edge from Chicago to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Chicago", to: "Denver"), "g6Cycle: Expected an edge from Chicago to Denver")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Denver", to: "Chicago"), "g6Cycle: Expected an edge from Denver to Chicago")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Denver", to: "Boston"), "g6Cycle: Expected an edge from Denver to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Denver"), "g6Cycle: Expected an edge from Boston to Denver")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Eugene"), "g6Cycle: Expected an edge from Boston to Eugene")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Eugene", to: "Boston"), "g6Cycle: Expected an edge from Eugene to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Eugene", to: "Atlanta"), "g6Cycle: Expected an edge from Eugene to Atlanta")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Atlanta", to: "Eugene"), "g6Cycle: Expected an edge from Atlanta to Eugene")
    }

    func testCycleInitializerDirected() {
        let g0Cycle = UnweightedUniqueElementsGraph<String>.withCycle([], directed: true)
        XCTAssertEqual(g0Cycle.vertexCount, 0, "g0Cycle: Expected empty graph")
        XCTAssertEqual(g0Cycle.edgeCount, 0, "g0Cycle: Expected empty graph")

        let g1Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta"], directed: true)
        XCTAssertEqual(g1Cycle.vertices, ["Atlanta"], "g1Cycle: Expected only Atlanta vertex")
        XCTAssertEqual(g1Cycle.edgeCount, 1, "g1Cycle: Expected 1 edge")
        XCTAssertTrue(g1Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g1Cycle: Expected an edge from Atlanta to Atlanta")

        let g2Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston"], directed: true)
        XCTAssertEqual(g2Cycle.vertices, ["Atlanta", "Boston"], "g2Cycle: Expected vertices to be Atlanta and Boston")
        XCTAssertEqual(g2Cycle.edgeCount, 2, "g2Cycle: Expected exactly 2 edges")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g2Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g2Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g2Cycle: Expected an edge from Atlanta to Boston")

        let g3Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago"], directed: true)
        XCTAssertEqual(g3Cycle.vertices, ["Atlanta", "Boston", "Chicago"], "g3Cycle: Expected vertices to be Atlanta, Boston and Chicago")
        XCTAssertEqual(g3Cycle.edgeCount, 3, "g3Cycle: Expected exactly 4 edges")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g3Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Boston", to: "Chicago"), "g3Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g3Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g3Cycle: Expected an edge from Chicago to Atlanta")

        let g4Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Atlanta"], directed: true)
        XCTAssertEqual(g4Cycle.vertices, ["Atlanta", "Boston"], "g4Cycle: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g4Cycle.edgeCount, 3, "g4Cycle: Expected exactly 3 edges")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g4Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Boston", to: "Atlanta"), "g4Cycle: Expected an edge from Boston to Atlanta")
        XCTAssertTrue(g4Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g4Cycle: Expected an edge from Atlanta to Boston")

        let g5Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago", "Atlanta", "Denver", "Chicago", "Atlanta"], directed: true)
        XCTAssertEqual(g5Cycle.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "g5Cycle: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g5Cycle.edgeCount, 6, "g5Path: Expected exactly 6 edges")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g5Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Boston", to: "Chicago"), "g5Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Chicago", to: "Atlanta"), "g5Cycle: Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Denver"), "g5Cycle: Expected an edge from Atlanta to Denver")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Denver", to: "Chicago"), "g5Cycle: Expected an edge from Denver to Chicago")
        XCTAssertTrue(g5Cycle.edgeExists(from: "Atlanta", to: "Atlanta"), "g5Cycle: Expected an edge from Atlanta to Boston")

        let g6Cycle = UnweightedUniqueElementsGraph.withCycle(["Atlanta", "Boston", "Chicago", "Denver", "Boston", "Eugene"], directed: true)
        XCTAssertEqual(g6Cycle.vertices, ["Atlanta", "Boston", "Chicago", "Denver", "Eugene"], "g6Cycle: Expected vertices to be Atlanta, Boston, Chiicago and Denver.")
        XCTAssertEqual(g6Cycle.edgeCount, 6, "g6Cycle: Expected exactly 6 edges")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Atlanta", to: "Boston"), "g6Cycle: Expected an edge from Atlanta to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Chicago"), "g6Cycle: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Chicago", to: "Denver"), "g6Cycle: Expected an edge from Chicago to Denver")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Denver", to: "Boston"), "g6Cycle: Expected an edge from Denver to Boston")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Boston", to: "Eugene"), "g6Cycle: Expected an edge from Boston to Eugene")
        XCTAssertTrue(g6Cycle.edgeExists(from: "Eugene", to: "Atlanta"), "g6Cycle: Expected an edge from Eugene to Atlanta")
    }
}

