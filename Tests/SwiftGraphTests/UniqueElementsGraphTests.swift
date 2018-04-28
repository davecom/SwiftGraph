//
//  UniqueElementsGraphTests.swift
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

class UniqueElementsGraphTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUniqueVertexAfterInit() {
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Atlanta"])
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }

    func testUniqueVertexAfterAddition() {
        let g = UniqueElementsGraph<String>()
        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")

        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }
    
    func testUniqueUndirectedEdges() {
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }
    
    func testUniqueDirectedEdges() {
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")
    }
    
    func testUniqueEdgesCombined() {
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.edgeExists(from: "Chicago", to: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    static var allTests = [
        ("testUniqueVertexAfterAddition", testUniqueVertexAfterAddition),
        ("testUniqueVertexAfterInit", testUniqueVertexAfterInit),
        ("testUniqueUndirectedEdges", testUniqueUndirectedEdges),
        ("testUniqueDirectedEdges", testUniqueDirectedEdges),
        ("testUniqueEdgesCombined", testUniqueEdgesCombined)
    ]
}