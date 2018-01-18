//
//  SwiftGraphTests.swift
//  SwiftGraphTests
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

class SwiftGraphTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCitesInverseAfterRemove() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(node: "Atlanta")
        g.add(node: "New York")
        g.add(node: "Miami")
        g.edge("Atlanta", to: "New York")
        g.edge("Miami", to: "Atlanta")
        g.edge("New York", to: "Miami")
        g.remove(node: "Atlanta")
        XCTAssertEqual(g.neighbors(for: "Miami")!, g.neighbors(for: g.neighbors(for: "New York")![0])!, "Miami and New York Connected bi-directionally")
    }

    func testSequenceTypeAndCollectionType() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(node: "Atlanta")
        g.add(node: "New York")
        g.add(node: "Miami")
        var tempList: [String] = []
        for v in g {
            tempList.append(v)
        }
        XCTAssertEqual(tempList, ["Atlanta", "New York", "Miami"], "Iterated Successfully")
        XCTAssertEqual(g[1], "New York", "Subscripted Successfully")
    }

    func testCounts() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(node: "Atlanta")
        g.add(node: "New York")
        g.add(node: "Miami")
        g.edge("Atlanta", to: "New York", directed: true)
        g.edge("Miami", to: "Atlanta", directed: true)
        g.edge("New York", to: "Miami", directed: true)
        g.edge("Atlanta", to: "Miami", directed: true)
        XCTAssertEqual(g.nodeCount, 3, "3 total nodes")
        XCTAssertEqual(g.edgeCount, 4, "4 total edges")
        g.remove(node: "Atlanta")
        XCTAssertEqual(g.nodeCount, 2, "2 total nodes")
        XCTAssertEqual(g.edgeCount, 1, "1 total edges")
    }

    func testSubscript() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(node: "Atlanta")
        g.add(node: "New York")
        g.add(node: "Miami")
        XCTAssertEqual(g[0], "Atlanta", "Expected result at node 0")
        XCTAssertEqual(g[2], "Miami", "Expected result at node 2")
    }

    func testVarious() {
        var g: _UnweightedGraph<String> = .init()

        g.add(node: "Atlanta")
        g.add(node: "Miami")
        g.edge("Atlanta", to: "Miami", directed: false)
        XCTAssertTrue(g.contains(node: "Atlanta"))
        XCTAssertFalse(g.contains(node: "New York"))

        let edge = g.edges(for: "Atlanta")!.first!
        XCTAssertTrue(g.contains(edge: edge))
        XCTAssertFalse(edge.weighted)

        g.remove(edge: edge)
        XCTAssertFalse(g.contains(edge: edge))

        g.edge("Lagos", to: "Atlanta")
        XCTAssertNil(g.edges(for: "Lagos"))

        g.edge("Atlanta", to: "Miami", directed: false)
        g.unedge("Atlanta", to: "Miami", bidirectional: true)
        g.unedge("Atlanta", to: "Rome", bidirectional: true)

        var wg1 = _WeightedGraph<String, Int>(nodes: ["0", "1"])
        var wg2 = _WeightedGraph<String, Int>(nodes: ["0", "1"])

        XCTAssertEqual(wg1.immutableNodes, wg2.immutableNodes)
        XCTAssertNil(wg1.neighbors(for: "3"))

        wg1.remove(node: "3")

        wg1.edge(0, to: 1, weight: 1)
        wg2.edge(0, to: 1, weight: 1)
        let weightedEdge = wg1.edges(for: 0).first!
        let anotherWeightedEdge = wg2.edges(for: 0).first!
        XCTAssertTrue(wg1.contains(edge: weightedEdge))
        XCTAssertEqual(weightedEdge, anotherWeightedEdge)

        XCTAssertTrue(wg1.edged(from: "0", to: "1"))
        XCTAssertFalse(wg1.edged(from: "0", to: "2"))

        XCTAssertTrue(weightedEdge.weighted)

        XCTAssertEqual(anotherWeightedEdge.description, "0 <1> 1")
        anotherWeightedEdge.directed = true
        XCTAssertEqual(anotherWeightedEdge.description, "0 1> 1")

        wg1.edge("3", to: "4", weight: 1)
        XCTAssertNil(wg1.edges(for: "3"))

        XCTAssertNil(wg1.topologicalSort())
        XCTAssertFalse(wg1.isDAG)

        let q = Queue<Int>()
        q.push(1)
        XCTAssertTrue(q.contains(1))
        XCTAssertFalse(q.contains(2))
        q.push(10)
        XCTAssertEqual(q.count, 2)
    }

    func testRemoveAllEdges() {
        // Note: The warning regarding mutability depends on the non-mutating class
        // methods. If we use a struct-based graph instead of a class-based on
        // the test won't compile because struct enforces its mutability requirements
        // while we are bypassing them with classes to allow those methods to be
        // used internally by the classes themselves (they couldn't be used if the
        // protocol specifies them as `mutating` and a `nonmutating` variant is not
        // provided.
        var graph = _UnweightedGraph(nodes: ["0", "1", "2", "3", "4", "5", "6"])
        graph.edge("0", to: "1", directed: false)
        graph.edge("1", to: "2", directed: false)
        graph.edge("2", to: "3", directed: false)
        graph.edge("3", to: "2", directed: false)
        graph.edge("3", to: "4", directed: false)
        graph.edge("4", to: "5", directed: false)
        graph.unedge(2, to: 3, bidirectional: true)
        XCTAssertFalse(graph.edged(from: 2, to: 3))
        XCTAssertFalse(graph.edged(from: 3, to: 2))
    }

    func testMutatingMethods() {
        var g1 = _UnweightedGraphStruct(nodes: ["0", "1", "2", "3", "4", "5", "6"])
        var g2 = _WeightedGraphStruct<String, Int>(nodes: ["0", "1", "2", "3", "4", "5", "6"])

        g1.edge(0, to: 1)
        g2.edge(0, to: 1, weight: 1)
        g1.edge("2", to: "3")
        g2.edge("2", to: "3", weight: 1)

        let e1 = g1.edges(for: 0).first!
        let e2 = g2.edges(for: 0).first!
        XCTAssertTrue(g1.contains(edge: e1))
        XCTAssertTrue(g2.contains(edge: e2))

        let e3 = g1.edges(for: "2")!.first!
        let e4 = g2.edges(for: "2")!.first!
        XCTAssertTrue(g1.contains(edge: e3))
        XCTAssertTrue(g2.contains(edge: e4))

        g1.remove(node: "6")
        XCTAssertFalse(g1.contains(node: "6"))

        let v1 = g1.node(at: 3)
        g1.remove(at: 3)
        XCTAssertFalse(g1.contains(node: v1))

        g1.remove(edge: e1)
        XCTAssertFalse(g1.contains(edge: e1))

        g2.unedge(0, to: 1, bidirectional: true)
        XCTAssertFalse(g2.contains(edge: e2))

        g2.unedge("2", to: "3", bidirectional: true)
        XCTAssertFalse(g2.contains(edge: e4))

        g1.edge("10", to: "11", directed: true)
        XCTAssertNil(g1.edges(for: "10"))

        g2.edge("10", to: "11", directed: true, weight: 1)
        XCTAssertNil(g2.edges(for: "10"))
    }

    static var allTests = [
        ("testCitesInverseAfterRemove", testCitesInverseAfterRemove),
        ("testSequenceTypeAndCollectionType", testSequenceTypeAndCollectionType),
        ("testCounts", testCounts),
        ("testSubscript", testSubscript),
        ("testRemoveAllEdges", testRemoveAllEdges),
        ("testVarious", testVarious),
        ("testMutatingMethods", testMutatingMethods),
    ]
}
