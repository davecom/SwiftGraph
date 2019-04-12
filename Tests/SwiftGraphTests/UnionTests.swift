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

    func testEmptyGraph() {
        let g = UnweightedUniqueElementsGraph<Int>.unionOf([])
        XCTAssertEqual(g.vertexCount, 0, "Expected 0 vertices on the empty graph.")
        XCTAssertEqual(g.edgeCount, 0, "Expected 0 edges on the empty graph.")
    }

    func testUnionLastInCommon() {
        let g1 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UnweightedUniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let u = UnweightedUniqueElementsGraph.unionOf(g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago"], "Expected vertices on the result graph to be Atlanta, Boston and Chicago.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Boston", to: "Chicago"), "Expected an edge from Boston to Chicago")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Boston"), "Expected an edge from Chicago to Boston")
    }

    func testUnionFirstInCommon() {
        let g1 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Chicago"])
        g2.addEdge(from: "Atlanta", to: "Chicago", directed: false)

        let u = UnweightedUniqueElementsGraph.unionOf(g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago"], "Expected vertices on the result graph to be Atlanta, Boston and Chicago.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Atlanta"), "Expected an edge from Chicago to Atlanta")
    }

    func testDisjointUnion() {
        let g1 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UnweightedUniqueElementsGraph(vertices: ["Chicago", "Denver"])
        g2.addEdge(from: "Chicago", to: "Denver", directed: false)

        let u = UnweightedUniqueElementsGraph.unionOf(g1, g2)

        XCTAssertEqual(u.vertices, ["Atlanta", "Boston", "Chicago", "Denver"], "Expected vertices on the result graph to be Atlanta, Boston, Chicago and Denver.")
        XCTAssertEqual(u.edgeCount, 3, "Expected 3 edges on the result graph.")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
        XCTAssertTrue(u.edgeExists(from: "Chicago", to: "Denver"), "Expected an edge from Chicago to Denver")
        XCTAssertTrue(u.edgeExists(from: "Denver", to: "Chicago"), "Expected an edge from Denver to Chicago")
    }

    func testImmutabilityOfInputGraphs() {
        let g1 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UnweightedUniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let _ = UnweightedUniqueElementsGraph.unionOf(g1, g2)

        XCTAssertEqual(g1.vertices, ["Atlanta", "Boston"], "g1: Expected vertices to be Atlanta and Boston.")
        XCTAssertEqual(g1.edgeCount, 1, "g1: Expected exactly 1 edge")
        XCTAssertTrue(g1.edgeExists(from: "Atlanta", to: "Boston"), "g1: Expected an edge from Atlanta to Boston")
        XCTAssertEqual(g2.vertices, ["Boston", "Chicago"], "g2: Expected vertices to be Boston and Chicago.")
        XCTAssertEqual(g2.edgeCount, 2, "g2: Expected exactly 2 edges")
        XCTAssertTrue(g2.edgeExists(from: "Boston", to: "Chicago"), "g2: Expected an edge from Boston to Chicago")
        XCTAssertTrue(g2.edgeExists(from: "Chicago", to: "Boston"), "g2: Expected an edge from Chicago to Boston")
    }


    func testIdentityEmptyGraph() {
        let eg = UnweightedUniqueElementsGraph<String>()
        let g = UnweightedUniqueElementsGraph<String>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        
        let result1 = UnweightedUniqueElementsGraph.unionOf(eg, g)
        
        XCTAssertEqual(result1.vertices, g.vertices, "Expected same vertices after left union with empty graph")
        XCTAssertEqual(result1.edgeCount, 1, "Expected same edge count after left union with empty graph")
        XCTAssertTrue(result1.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after left union with empty graph")
        
        let result2 = UnweightedUniqueElementsGraph.unionOf(g, eg)
        
        XCTAssertEqual(result2.vertices, g.vertices, "Expected same vertices after right union with empty graph")
        XCTAssertEqual(result2.edgeCount, 1, "Expected same edge count after right union with empty graph")
        XCTAssertTrue(result2.edgeExists(from: "Atlanta", to: "Chicago"), "Expected an edge from Chicago to Atlanta after right union with empty graph")
    }

    func testUnionWithSelf() {
        let g = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", directed: true)

        let u = UnweightedUniqueElementsGraph.unionOf(g, g)
        XCTAssertEqual(u.vertices, g.vertices, "Expected same vertices after union with self")
        XCTAssertEqual(u.edgeCount, 1, "Expected same edge count after union to self")
        XCTAssertTrue(u.edgeExists(from: "Atlanta", to: "Boston"), "Expected an edge from Atlanta to Boston")
    }

    func testCommutativity() {
        let g1 = UnweightedUniqueElementsGraph(vertices: ["Atlanta", "Boston"])
        g1.addEdge(from: "Atlanta", to: "Boston", directed: true)
        let g2 = UnweightedUniqueElementsGraph(vertices: ["Boston", "Chicago"])
        g2.addEdge(from: "Boston", to: "Chicago", directed: false)

        let u12 = UnweightedUniqueElementsGraph.unionOf(g1, g2)
        let u21 = UnweightedUniqueElementsGraph.unionOf(g2, g1)
        // Both result graph must have the same vertices but they can be in different order.
        XCTAssertTrue(arraysHaveSameElements(u12.vertices, u21.vertices), "Expected same vertices for g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Atlanta")!, u21.neighborsForVertex("Atlanta")!), "Expected same neighbors of Atlanta in g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Boston")!, u21.neighborsForVertex("Boston")!), "Expected same neighbors of Boston in g1 ∪ g2 and g2 ∪ g1")
        XCTAssertTrue(arraysHaveSameElements(u12.neighborsForVertex("Chicago")!, u21.neighborsForVertex("Chicago")!), "Expected same neighbors of Chicago in g1 ∪ g2 and g2 ∪ g1")
    }

    func testAssociativity() {
        let g1 = UnweightedUniqueElementsGraph.withPath(["A", "B"])
        let g2 = UnweightedUniqueElementsGraph.withPath(["B", "C"])
        let g3 = UnweightedUniqueElementsGraph.withPath(["C", "A"])

        let g12 = UnweightedUniqueElementsGraph.unionOf(g1, g2)
        let g12_3 = UnweightedUniqueElementsGraph.unionOf(g12, g3)

        let g23 = UnweightedUniqueElementsGraph.unionOf(g2, g3)
        let g1_23 = UnweightedUniqueElementsGraph.unionOf(g1, g23)

        XCTAssertTrue(arraysHaveSameElements(g12_3.vertices, g1_23.vertices), "Expected same vertices for (g1 ∪ g2) ∪ g3 and g1 ∪ (g2 ∪ g3)")

        XCTAssertTrue(g12_3.edgeExists(from: "A", to: "B"), "(g1 ∪ g2) ∪ g3: Expected an edge from A to B")
        XCTAssertTrue(g12_3.edgeExists(from: "B", to: "C"), "(g1 ∪ g2) ∪ g3: Expected an edge from B to C")
        XCTAssertTrue(g12_3.edgeExists(from: "C", to: "A"), "(g1 ∪ g2) ∪ g3: Expected an edge from C to A")

        XCTAssertTrue(g1_23.edgeExists(from: "A", to: "B"), "g1 ∪ (g2 ∪ g3): Expected an edge from A to B")
        XCTAssertTrue(g1_23.edgeExists(from: "B", to: "C"), "g1 ∪ (g2 ∪ g3): Expected an edge from B to C")
        XCTAssertTrue(g1_23.edgeExists(from: "C", to: "A"), "g1 ∪ (g2 ∪ g3): Expected an edge from C to A")
    }

    func testMultipleParameters() {
        let g1 = UnweightedUniqueElementsGraph.withPath(["A", "B"])
        let g2 = UnweightedUniqueElementsGraph.withPath(["B", "C"])
        let g3 = UnweightedUniqueElementsGraph.withPath(["C", "A"])

        let g = UnweightedUniqueElementsGraph.unionOf(g1, g2, g3)

        XCTAssertEqual(g.vertices, ["A", "B", "C"], "g: Expected vertices to be A, B and C")
        XCTAssertTrue(g.edgeExists(from: "A", to: "B"), "g: Expected an edge from A to B")
        XCTAssertTrue(g.edgeExists(from: "B", to: "C"), "g: Expected an edge from B to C")
        XCTAssertTrue(g.edgeExists(from: "C", to: "A"), "g: Expected an edge from C to A")
    }
}
