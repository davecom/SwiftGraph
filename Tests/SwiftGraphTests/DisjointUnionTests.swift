//
//  DisjointUnionTests.swift
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

class DisjointUnionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // TODO: test copy semantics

    func testIdentityEmptyGraph() {
        let eg = UniqueElementsGraph<String>()
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        
        let result1 = UniqueElementsGraph(disjointUnionOf: eg, g)
        
        XCTAssertEqual(result1.vertices, g.vertices, "Expected same vertices after left union with empty graph")
        XCTAssertEqual(result1.edgeCount, 1, "Expected same edge count after left union with empty graph")
        XCTAssertTrue(result1.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after left union with empty graph")
        
        let result2 = UniqueElementsGraph(disjointUnionOf: g, eg)
        
        XCTAssertEqual(result2.vertices, g.vertices, "Expected same vertices after right union with empty graph")
        XCTAssertEqual(result2.edgeCount, 1, "Expected same edge count after right union with empty graph")
        XCTAssertTrue(result2.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after right union with empty graph")
    }

    static var allTests = [
        ("testIdentityEmptyGraph", testIdentityEmptyGraph)
    ]
}
