//
//  SwiftGraphSearchTests.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2016 David Kopec
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

class SwiftGraphSearchTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1016 Liang
        cityGraph.addEdge(from: "Seattle", to: "Chicago")
        cityGraph.addEdge(from: "Seattle", to: "Denver")
        cityGraph.addEdge(from: "Seattle", to: "San Francisco")
        cityGraph.addEdge(from: "San Francisco", to: "Denver")
        cityGraph.addEdge(from: "San Francisco", to: "Los Angeles")
        cityGraph.addEdge(from: "Los Angeles", to: "Denver")
        cityGraph.addEdge(from: "Los Angeles", to: "Kansas City")
        cityGraph.addEdge(from: "Los Angeles", to: "Dallas")
        cityGraph.addEdge(from: "Denver", to: "Chicago")
        cityGraph.addEdge(from: "Denver", to: "Kansas City")
        cityGraph.addEdge(from: "Kansas City", to: "Chicago")
        cityGraph.addEdge(from: "Kansas City", to: "New York")
        cityGraph.addEdge(from: "Kansas City", to: "Atlanta")
        cityGraph.addEdge(from: "Kansas City", to: "Dallas")
        cityGraph.addEdge(from: "Chicago", to: "Boston")
        cityGraph.addEdge(from: "Chicago", to: "New York")
        cityGraph.addEdge(from: "Boston", to: "New York")
        cityGraph.addEdge(from: "Atlanta", to: "New York")
        cityGraph.addEdge(from: "Atlanta", to: "Dallas")
        cityGraph.addEdge(from: "Atlanta", to: "Houston")
        cityGraph.addEdge(from: "Atlanta", to: "Miami")
        cityGraph.addEdge(from: "Houston", to: "Miami")
        cityGraph.addEdge(from: "Houston", to: "Dallas")
        print(cityGraph.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDFS1() {
        // Seattle -> Miami
        let result = dfs(from: "Seattle", to: "Miami", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testDFS2() {
        // Boston -> LA
        let result = dfs(from: "Boston", to: "Los Angeles", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testBFS1() {
        // Seattle -> Miami
        let result = bfs(from: "Seattle", to: "Miami", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Seattle to Miami")
        print(edgesToVertices(edges: result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testBFS2() {
        // Boston -> LA
        let result = bfs(from: "Boston", to: "Los Angeles", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Boston to Los Angeles")
        print(edgesToVertices(edges: result, graph: cityGraph))  // not sure why description not called by println
    }
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}
