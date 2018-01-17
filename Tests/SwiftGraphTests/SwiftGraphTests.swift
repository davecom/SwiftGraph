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
        g.add(vertex: "Atlanta")
        g.add(vertex: "New York")
        g.add(vertex: "Miami")
        g.edge("Atlanta", to: "New York")
        g.edge("Miami", to: "Atlanta")
        g.edge("New York", to: "Miami")
        g.remove(vertex: "Atlanta")
        XCTAssertEqual(g.neighbors(for: "Miami")!, g.neighbors(for: g.neighbors(for: "New York")![0])!, "Miami and New York Connected bi-directionally")
    }

    func testSequenceTypeAndCollectionType() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(vertex: "Atlanta")
        g.add(vertex: "New York")
        g.add(vertex: "Miami")
        var tempList: [String] = []
        for v in g {
            tempList.append(v)
        }
        XCTAssertEqual(tempList, ["Atlanta", "New York", "Miami"], "Iterated Successfully")
        XCTAssertEqual(g[1], "New York", "Subscripted Successfully")
    }

    func testCounts() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(vertex: "Atlanta")
        g.add(vertex: "New York")
        g.add(vertex: "Miami")
        g.edge("Atlanta", to: "New York", directed: true)
        g.edge("Miami", to: "Atlanta", directed: true)
        g.edge("New York", to: "Miami", directed: true)
        g.edge("Atlanta", to: "Miami", directed: true)
        XCTAssertEqual(g.vertexCount, 3, "3 total vertices")
        XCTAssertEqual(g.edgeCount, 4, "4 total edges")
        g.remove(vertex: "Atlanta")
        XCTAssertEqual(g.vertexCount, 2, "2 total vertices")
        XCTAssertEqual(g.edgeCount, 1, "1 total edges")
    }

    func testSubscript() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add(vertex: "Atlanta")
        g.add(vertex: "New York")
        g.add(vertex: "Miami")
        XCTAssertEqual(g[0], "Atlanta", "Expected result at vertex 0")
        XCTAssertEqual(g[2], "Miami", "Expected result at vertex 2")
    }

    func testRemoveAllEdges() {
        var graph = _UnweightedGraph(vertices: ["0", "1", "2", "3", "4", "5", "6"])
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

    // func testPerformanceExample() {
    // This is an example of a performance test case.
    //   self.measureBlock() {
    // Put the code you want to measure the time of here.
    //   }
    // }
    static var allTests = [
        ("testCitesInverseAfterRemove", testCitesInverseAfterRemove),
        ("testSequenceTypeAndCollectionType", testSequenceTypeAndCollectionType),
        ("testCounts", testCounts),
        ("testSubscript", testSubscript),
        ("testRemoveAllEdges", testRemoveAllEdges),
    ]
}
