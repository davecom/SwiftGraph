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

import Foundation
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

    func testIndegreeAndOutdegree() {
        var g = UnweightedGraph<String>()
        let atlantaIndex = g.addVertex("Atlanta")
        let nyIndex = g.addVertex("New York")
        let miamiIndex = g.addVertex("Miami")
        let sfIndex = g.addVertex("San Francisco")
        let arezzoIndex = g.addVertex("Arezzo")
        g.addEdge(from: "Atlanta", to: "New York", directed: true)
        let nyAtlantaEdge = UnweightedEdge(u: nyIndex, v: atlantaIndex, directed: true)
        g.addEdge(nyAtlantaEdge)
        g.addEdge(from: "Miami", to: "Atlanta", directed: true)
        g.addEdge(from: "New York", to: "Miami", directed: false)
        g.addEdge(from: "Atlanta", to: "Miami", directed: true)
        g.addEdge(from: "San Francisco", to: "Miami", directed: false)
        XCTAssertEqual(g.indegreeOfVertex(at: atlantaIndex), 2, "2 edges end at Atlanta")
        XCTAssertEqual(g.indegreeOfVertex(at: miamiIndex), 3, "3 edges end at Miami")
        XCTAssertEqual(g.indegreeOfVertex(at: sfIndex), 1, "1 edge ends at San Francisco")
        XCTAssertEqual(g.indegreeOfVertex(at: nyIndex), 2, "2 edges end at New York")
        XCTAssertEqual(g.indegreeOfVertex(at: arezzoIndex), 0, "0 edges end at Arezzo")
        XCTAssertEqual(g.outdegreeOfVertex(at: atlantaIndex), 2, "2 edges start from Atlanta")
        XCTAssertEqual(g.outdegreeOfVertex(at: miamiIndex), 3, "3 edges start from Miami")
        XCTAssertEqual(g.outdegreeOfVertex(at: sfIndex), 1, "1 edge starts from San Francisco")
        XCTAssertEqual(g.outdegreeOfVertex(at: nyIndex), 2, "2 edges start from New York")
        XCTAssertEqual(g.outdegreeOfVertex(at: arezzoIndex), 0, "0 edges start from Arezzo")
        g.removeEdge(nyAtlantaEdge)
        XCTAssertEqual(g.indegreeOfVertex(at: atlantaIndex), 1, "1 edgee ends at Atlanta")
        XCTAssertEqual(g.indegreeOfVertex(at: miamiIndex), 3, "3 edges end at Miami")
        XCTAssertEqual(g.indegreeOfVertex(at: sfIndex), 1, "1 edge ends at San Francisco")
        XCTAssertEqual(g.indegreeOfVertex(at: nyIndex), 2, "2 edges end at New York")
        XCTAssertEqual(g.indegreeOfVertex(at: arezzoIndex), 0, "0 edges end at Arezzo")
        XCTAssertEqual(g.outdegreeOfVertex(at: atlantaIndex), 2, "2 edges start from Atlanta")
        XCTAssertEqual(g.outdegreeOfVertex(at: miamiIndex), 3, "3 edges start from Miami")
        XCTAssertEqual(g.outdegreeOfVertex(at: sfIndex), 1, "1 edge starts from San Francisco")
        XCTAssertEqual(g.outdegreeOfVertex(at: nyIndex), 1, "1 edge starts from New York")
        XCTAssertEqual(g.outdegreeOfVertex(at: arezzoIndex), 0, "0 edges start from Arezzo")
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

    // a trivial smoke test to exercise the methods added to Graph to
    // perform exhaustive searches for paths.
    func testExhaustivePathCounting() throws {
        let graph = try getAoCGraph()
        guard let fftIndex = graph.indexOfVertex("fft") else {
            XCTFail("Bad graph, no fft")
            return
        }
        guard let dacIndex = graph.indexOfVertex("dac") else {
            XCTFail("Bad graph, no dac")
            return
        }
        guard let outIndex = graph.indexOfVertex("out") else {
            XCTFail("Bad graph, no out")
            return
        }
        guard let svrIndex = graph.indexOfVertex("svr") else {
            XCTFail("Bad graph, no svr")
            return
        }
        var visited: Set<Int> = [svrIndex, outIndex]
        XCTAssertEqual(0, graph.countPaths(fromIndex: dacIndex, toIndex: fftIndex, visited: &visited))
        let outReachability = graph.reachabilityOf(outIndex)
        visited = [svrIndex, fftIndex]
        XCTAssertEqual(2,
                       graph.countPaths(fromIndex: dacIndex,
                                        toIndex: outIndex,
                                        visited: &visited,
                                        reachability: outReachability))
    }

    fileprivate func getAoCGraph() throws -> UnweightedGraph<String> {
        // this is the sample graph for part 2 of the 2025 Advent of Code challenge, day 11.
        let serializedGraph = """
            {"vertices":["hhh","ddd","fft","ccc","svr","fff","eee","aaa","bbb","hub","ggg","dac","tty","out"],"edges":[[{"u":0,"v":13,"directed":true}],[{"u":1,"v":9,"directed":true}],[{"u":2,"v":3,"directed":true}],[{"u":3,"v":1,"directed":true},{"u":3,"v":6,"directed":true}],[{"u":4,"v":7,"directed":true},{"u":4,"v":8,"directed":true}],[{"u":5,"v":10,"directed":true},{"u":5,"v":0,"directed":true}],[{"u":6,"v":11,"directed":true}],[{"u":7,"v":2,"directed":true}],[{"u":8,"v":12,"directed":true}],[{"u":9,"v":5,"directed":true}],[{"u":10,"v":13,"directed":true}],[{"u":11,"v":5,"directed":true}],[{"u":12,"v":3,"directed":true}],[]]}
            """
        return try JSONDecoder().decode(UnweightedGraph<String>.self, from: serializedGraph.data(using: .utf8)!)
    }
}
