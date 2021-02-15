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

import XCTest
@testable import SwiftGraph

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
        var g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York")
        g.addEdge(from: "Miami", to: "Atlanta")
        g.addEdge(from: "New York", to: "Miami")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.neighborsForVertex("Miami")!, g.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miami and New York Connected bi-directionally")
    }
    
    func testSequenceTypeAndCollectionType() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        var tempList: [String] = []
        for v in g {
            tempList.append(v)
        }
        XCTAssertEqual(tempList, ["Atlanta", "New York", "Miami"], "Iterated Successfully")
        XCTAssertEqual(g[1], "New York", "Subscripted Successfully")
    }
    
    func testCounts() {
        var g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York", directed: true)
        g.addEdge(from: "Miami", to: "Atlanta", directed: true)
        g.addEdge(from: "New York", to: "Miami", directed: true)
        g.addEdge(from: "Atlanta", to: "Miami", directed: true)
        XCTAssertEqual(g.vertexCount, 3, "3 total vertices")
        XCTAssertEqual(g.edgeCount, 4, "4 total edges")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.vertexCount, 2, "2 total vertices")
        XCTAssertEqual(g.edgeCount, 1, "1 total edges")
    }
    
    func testSubscript() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        XCTAssertEqual(g[0], "Atlanta", "Expected result at vertex 0")
        XCTAssertEqual(g[2], "Miami", "Expected result at vertex 2")
    }
    
    func testRemoveAllEdges() {
        var graph = UnweightedGraph(vertices: ["0", "1", "2", "3", "4", "5", "6"])
        
        graph.addEdge(from: "0", to: "1", directed: false)
        graph.addEdge(from: "1", to: "2", directed: false)
        graph.addEdge(from: "2", to: "3", directed: false)
        graph.addEdge(from: "3", to: "2", directed: false)
        graph.addEdge(from: "3", to: "4", directed: false)
        graph.addEdge(from: "4", to: "5", directed: false)
        
        graph.removeAllEdges(from: 2, to: 3, bidirectional: true)
        XCTAssertFalse(graph.edgeExists(fromIndex: 2, toIndex: 3))
        XCTAssertFalse(graph.edgeExists(fromIndex: 3, toIndex: 2))
    }
    
    func testCitesReversedDirected() {
        let g = UnweightedGraph<String>(vertices: ["Atlanta", "New York", "Miami"])
        g.addEdge(from: "Atlanta", to: "New York", directed: true)
        g.addEdge(from: "Miami", to: "Atlanta", directed: true)
        g.addEdge(from: "New York", to: "Miami", directed: true)
        
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(g.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(g.edgeExists(from: "New York", to: "Miami"))
        
        let r: UnweightedGraph<String> = g.reversed()
        XCTAssertFalse(r.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertFalse(r.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertFalse(r.edgeExists(from: "New York", to: "Miami"))
        
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "Miami"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "New York"))
    }
    
    func testCitesReversedUndirected() {
        let g = UnweightedGraph<String>(vertices: ["Atlanta", "New York", "Miami"])
        g.addEdge(from: "Atlanta", to: "New York", directed: false)
        g.addEdge(from: "Miami", to: "Atlanta", directed: false)
        g.addEdge(from: "New York", to: "Miami", directed: false)
        
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(g.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(g.edgeExists(from: "New York", to: "Miami"))
        
        let r: UnweightedGraph<String> = g.reversed()
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Miami"))
        
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "Miami"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "New York"))
    }
}
