//
//  SwiftGraphSearchTests.swift
//  SwiftGraph
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

class SwiftGraphSearchTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    // 15 largest MSAs in United States as of 2016
    let cityGraph2: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])
    
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
        
        cityGraph2.addEdge(from: "Seattle", to: "Chicago")
        cityGraph2.addEdge(from: "Seattle", to: "San Francisco")
        cityGraph2.addEdge(from: "San Francisco", to: "Riverside")
        cityGraph2.addEdge(from: "San Francisco", to: "Los Angeles")
        cityGraph2.addEdge(from: "Los Angeles", to: "Riverside")
        cityGraph2.addEdge(from: "Los Angeles", to: "Phoenix")
        cityGraph2.addEdge(from: "Riverside", to: "Phoenix")
        cityGraph2.addEdge(from: "Riverside", to: "Chicago")
        cityGraph2.addEdge(from: "Phoenix", to: "Dallas")
        cityGraph2.addEdge(from: "Phoenix", to: "Houston")
        cityGraph2.addEdge(from: "Dallas", to: "Chicago")
        cityGraph2.addEdge(from: "Dallas", to: "Atlanta")
        cityGraph2.addEdge(from: "Dallas", to: "Houston")
        cityGraph2.addEdge(from: "Houston", to: "Atlanta")
        cityGraph2.addEdge(from: "Houston", to: "Miami")
        cityGraph2.addEdge(from: "Atlanta", to: "Chicago")
        cityGraph2.addEdge(from: "Atlanta", to: "Washington")
        cityGraph2.addEdge(from: "Atlanta", to: "Miami")
        cityGraph2.addEdge(from: "Miami", to: "Washington")
        cityGraph2.addEdge(from: "Chicago", to: "Detroit")
        cityGraph2.addEdge(from: "Detroit", to: "Boston")
        cityGraph2.addEdge(from: "Detroit", to: "Washington")
        cityGraph2.addEdge(from: "Detroit", to: "New York")
        cityGraph2.addEdge(from: "Boston", to: "New York")
        cityGraph2.addEdge(from: "New York", to: "Philadelphia")
        cityGraph2.addEdge(from: "Philadelphia", to: "Washington")
        print(cityGraph2.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDFS1() {
        // Seattle -> Miami
        let result = cityGraph.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph))
    }
    
    func testDFS2() {
        // Boston -> LA
        let result = cityGraph.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph))
    }
    
    func testDFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.characters.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testDFS4() {
        // Seattle -> Miami
        let result = cityGraph2.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testDFS5() {
        // Boston -> LA
        let result = cityGraph2.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testDFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.characters.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testBFS1() {
        // Seattle -> Miami
        let result = cityGraph.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Seattle to Miami")
        print(edgesToVertices(edges: result, graph: cityGraph))
    }
    
    func testBFS2() {
        // Boston -> LA
        let result = cityGraph.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Boston to Los Angeles")
        print(edgesToVertices(edges: result, graph: cityGraph))
    }
    
    func testBFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph.bfs(from: "Houston") { v in
            return v.characters.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph))
    }
    
    func testBFS4() {
        // Seattle -> Miami
        let result = cityGraph2.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Seattle to Miami")
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testBFS5() {
        // Boston -> LA
        let result = cityGraph2.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Boston to Los Angeles")
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testBFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.bfs(from: "Houston") { v in
            return v.characters.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(edgesToVertices(edges: result, graph: cityGraph2))
    }
    
    func testFindAll() {
        // New York -> all cities starting with "S"
        let result = cityGraph.findAll(from: "New York") { v in
            return v.characters.first == "S"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find any connections between New York and a city starting with S (there is one).")
        XCTAssertEqual(result.count, 2, "Should be 2 cities found starting with S")
        if let last = result.last, let first = result.first {
            let pathOne = edgesToVertices(edges: last, graph: cityGraph)
            print(pathOne)
            let pathTwo = edgesToVertices(edges: first, graph: cityGraph)
            print(pathTwo)
            let endCities = [pathOne.last!, pathTwo.last!]
            XCTAssertTrue(endCities.contains("Seattle"), "Should contain a route to Seattle")
            XCTAssertTrue(endCities.contains("San Francisco"), "Should contain a route to San Francisco")
        }
    }
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/
    static var allTests = [
        ("testDFS1", testDFS1),
        ("testDFS2", testDFS2),
        ("testDFS3", testDFS3),
        ("testDFS4", testDFS4),
        ("testDFS5", testDFS5),
        ("testDFS6", testDFS6),
        ("testBFS1", testBFS1),
        ("testBFS2", testBFS2),
        ("testBFS3", testBFS3),
        ("testBFS4", testBFS4),
        ("testBFS5", testBFS5),
        ("testBFS6", testBFS6),
        ("testFindAll", testFindAll)
    ]
}
