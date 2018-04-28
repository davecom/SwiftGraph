//
//  UnionTests.swift
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

class UnionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUnionLastInCommon() {
        let g1 = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let u = UniqueElementsGraph(unionOf: g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago"], "Expected vertices on the result graph to be Atlanta, Boston and Chicago.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Boston", to: "Chicago"), "Expected an edge from Boston to Chicago")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Boston"), "Expected an edge from Chicago to Boston")
    }

    func testUnionFirstInCommon() {
        let g1 = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UniqueElementsGraph(vertices: ["Atlanta", "Chicago"])
        g2.addEdge(from: "Atlanta", to: "Chicago", directed: false)

        let u = UniqueElementsGraph(unionOf: g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago"], "Expected vertices on the result graph to be Atlanta, Boston and Chicago.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Atlanta"), "Expected an edge from Chicago to Atlanta")
    }

    func testDisjointUnion() {
        let g1 = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UniqueElementsGraph(vertices: ["Chicago", "Denver"])
        g2.addEdge(from: "Chicago", to: "Denver", directed: false)

        let u = UniqueElementsGraph(unionOf: g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "Expected vertices on the result graph to be Atlanta, Boston, Chicago and Denver.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Denver"), "Expected an edge from Chicago to Denver")
        XCTAssertTrue(u.edgeExists(from: "Denver", to: "Chicago"), "Expected an edge from Denver to Chicago")
    }

    func testImmutabilityOfInputGraphs() {
        let g1 = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let _ = UniqueElementsGraph(unionOf: g1, g2)

        XCTAssertEqual(g1.vertices, ["Atlanta", "Boston"], "g1: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g1.edgeCount, 1, "g1: Expected exactly 1 edge")
        XCTAssertTrue(g1.edgeExists(from: "Atlanta", to: "Boston"), "g1: Expected an edge from Atlanta to Boston")
        XCTAssertEqual(g2.vertices, ["Boston", "Chicago"], "g2: Expected vertices to be Boston and Chicago.")
        XCTAssertEqual(g2.edgeCount, 2, "g2: Expected exactly 2 edges")
        XCTAssertTrue(g2.edgeExists(from: "Boston", to: "Chicago"), "g2: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g2.edgeExists(from: "Chicago", to: "Boston"), "g2: Expected an edge from Chicago to Boston")
    }


    func testIdentityEmptyGraph() {
        let eg = UniqueElementsGraph<String>()
        let g = UniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        
        let result1 = UniqueElementsGraph(unionOf: eg, g)
        
        XCTAssertEqual(result1.vertices, g.vertices, "Expected same vertices after left union with empty graph")
        XCTAssertEqual(result1.edgeCount, 1, "Expected same edge count after left union with empty graph")
        XCTAssertTrue(result1.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after left union with empty graph")
        
        let result2 = UniqueElementsGraph(unionOf: g, eg)
        
        XCTAssertEqual(result2.vertices, g.vertices, "Expected same vertices after right union with empty graph")
        XCTAssertEqual(result2.edgeCount, 1, "Expected same edge count after right union with empty graph")
        XCTAssertTrue(result2.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after right union with empty graph")
    }

    func testUnionWithSelf() {
        let g = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", directed: true)

        let u = UniqueElementsGraph(unionOf: g, g)
        XCTAssertEqual(u.vertices, g.vertices, "Expected same vertices after union with self")
        XCTAssertEqual(u.edgeCount, 1, "Expected same edge count after union to self")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
    }

    func testCommutativity() {
        let g1 = UniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let u12 = UniqueElementsGraph(unionOf: g1, g2)
        let u21 = UniqueElementsGraph(unionOf: g2, g1)
        // Both result graph must have the same vertices but they can be in different order.
        XCTAssertTrue(arraysHaveSameElements(u12.vertices, u21.vertices), "Expected same vertices for g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Atlanta")!, u21.neighborsForVertex("Atlanta")!), "Expected same neighbors of Atlanta in g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Boston")!, u21.neighborsForVertex("Boston")!), "Expected same neighbors of Boston in g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Chicago")!, u21.neighborsForVertex("Chicago")!), "Expected same neighbors of Chicago in g1 ∪ g2 and g2 ∪ g1")
    }

    func associativityTest() {

    }

    static var allTests = [
        ("testUnionLastInCommon", testUnionLastInCommon),
        ("testUnionFirstInCommon", testUnionFirstInCommon),
        ("testDisjointUnion", testDisjointUnion),
        ("testImmutabilityOfInputGraphs", testImmutabilityOfInputGraphs),
        ("testIdentityEmptyGraph", testIdentityEmptyGraph),
        ("testUnionWithSelf", testUnionWithSelf),
        ("testCommutativity", testCommutativity)
    ]

    func arraysHaveSameElements<T: Equatable>(_ a1: [T], _ a2: [T]) -> Bool {
        guard a1.count == a2.count else {
            return false
        }

        for e in a1 {
            if !a2.contains(e) {
                return false
            }
        }
        return true
    }
}