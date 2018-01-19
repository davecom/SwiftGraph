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

@testable import SwiftGraph
import XCTest

class SwiftGraphSearchTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])

    // 15 largest MSAs in United States as of 2016
    let cityGraph2: _UnweightedGraph<String> = _UnweightedGraph<String>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington", "Cleveland"])

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1016 Liang
        cityGraph.edge("Seattle", to: "Chicago")
        cityGraph.edge("Seattle", to: "Denver")
        cityGraph.edge("Seattle", to: "San Francisco")
        cityGraph.edge("San Francisco", to: "Denver")
        cityGraph.edge("San Francisco", to: "Los Angeles")
        cityGraph.edge("Los Angeles", to: "Denver")
        cityGraph.edge("Los Angeles", to: "Kansas City")
        cityGraph.edge("Los Angeles", to: "Dallas")
        cityGraph.edge("Denver", to: "Chicago")
        cityGraph.edge("Denver", to: "Kansas City")
        cityGraph.edge("Kansas City", to: "Chicago")
        cityGraph.edge("Kansas City", to: "New York")
        cityGraph.edge("Kansas City", to: "Atlanta")
        cityGraph.edge("Kansas City", to: "Dallas")
        cityGraph.edge("Chicago", to: "Boston")
        cityGraph.edge("Chicago", to: "New York")
        cityGraph.edge("Boston", to: "New York")
        cityGraph.edge("Atlanta", to: "New York")
        cityGraph.edge("Atlanta", to: "Dallas")
        cityGraph.edge("Atlanta", to: "Houston")
        cityGraph.edge("Atlanta", to: "Miami")
        cityGraph.edge("Houston", to: "Miami")
        cityGraph.edge("Houston", to: "Dallas")
        print(cityGraph.description)

        cityGraph2.edge("Seattle", to: "Chicago")
        cityGraph2.edge("Seattle", to: "San Francisco")
        cityGraph2.edge("San Francisco", to: "Riverside")
        cityGraph2.edge("San Francisco", to: "Los Angeles")
        cityGraph2.edge("Los Angeles", to: "Riverside")
        cityGraph2.edge("Los Angeles", to: "Phoenix")
        cityGraph2.edge("Riverside", to: "Phoenix")
        cityGraph2.edge("Riverside", to: "Chicago")
        cityGraph2.edge("Phoenix", to: "Dallas")
        cityGraph2.edge("Phoenix", to: "Houston")
        cityGraph2.edge("Dallas", to: "Chicago")
        cityGraph2.edge("Dallas", to: "Atlanta")
        cityGraph2.edge("Dallas", to: "Houston")
        cityGraph2.edge("Houston", to: "Atlanta")
        cityGraph2.edge("Houston", to: "Miami")
        cityGraph2.edge("Atlanta", to: "Chicago")
        cityGraph2.edge("Atlanta", to: "Washington")
        cityGraph2.edge("Atlanta", to: "Miami")
        cityGraph2.edge("Miami", to: "Washington")
        cityGraph2.edge("Chicago", to: "Detroit")
        cityGraph2.edge("Detroit", to: "Boston")
        cityGraph2.edge("Detroit", to: "Washington")
        cityGraph2.edge("Detroit", to: "New York")
        cityGraph2.edge("Boston", to: "New York")
        cityGraph2.edge("New York", to: "Philadelphia")
        cityGraph2.edge("Philadelphia", to: "Washington")
        print(cityGraph2.description)
    }

    func testDFS1() {
        // Seattle -> Miami
        let result = cityGraph.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.node(at: last.target), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.node(at: first.source), "Seattle", "Seattle is not the start")
        }
        print(cityGraph.nodes(from: result))
    }

    func testDFS2() {
        // Boston -> LA
        let result = cityGraph.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.node(at: last.target), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.node(at: first.source), "Boston", "Boston is not the start")
        }
        print(cityGraph.nodes(from: result))
    }

    func testDFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Houston", "Houston is not the start")
        }
        print(cityGraph2.nodes(from: result))
    }

    func testDFS4() {
        // Seattle -> Miami
        let result = cityGraph2.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Seattle", "Seattle is not the start")
        }
        print(cityGraph2.nodes(from: result))
    }

    func testDFS5() {
        // Boston -> LA
        let result = cityGraph2.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Boston", "Boston is not the start")
        }
        print(cityGraph2.nodes(from: result))
    }

    func testDFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Houston", "Houston is not the start")
        }
        print(cityGraph2.nodes(from: result))
    }

    func testEmptyDFS() {
        var result = cityGraph2.dfs(from: "Houston") { $0 == "Rome" }
        XCTAssertTrue(result.isEmpty, "Not found when the test is false.")
        result = cityGraph2.dfs(from: "Rome") { $0 == "Milan" }
        XCTAssertTrue(result.isEmpty, "Not found when both the node and the test are false.")
        result = cityGraph2.dfs(from: cityGraph2.index(of: "Seattle")!, to: cityGraph2.index(of: "Cleveland")!)
        XCTAssertTrue(result.isEmpty, "Not found when the nodes are not connected.")
        result = cityGraph2.dfs(from: "Rome", to: "Seattle")
        XCTAssertTrue(result.isEmpty, "Not found when a node does not exist.")
    }

    func testEmptyBFS() {
        var result = cityGraph2.bfs(from: "Houston") { $0 == "Rome" }
        XCTAssertTrue(result.isEmpty, "Not found when the test is false.")
        result = cityGraph2.bfs(from: "Rome") { $0 == "Milan" }
        XCTAssertTrue(result.isEmpty, "Not found when both the node and the test are false.")
        result = cityGraph2.bfs(from: cityGraph2.index(of: "Seattle")!, to: cityGraph2.index(of: "Cleveland")!)
        XCTAssertTrue(result.isEmpty, "Not found when the nodes are not connected.")
        result = cityGraph2.bfs(from: "Rome", to: "Seattle")
        XCTAssertTrue(result.isEmpty, "Not found when a node does not exist.")
    }

    func testEmptyRoutes() {
        let result2 = cityGraph2.routes(from: "Rome", until: { $0 == "Milan" })
        XCTAssertTrue(result2.isEmpty, "No route from non-existing node to non-existing test.")
        let result3 = cityGraph2.route(from: "Rome", to: "Milan", in: [:])
        XCTAssertTrue(result3.isEmpty, "No route in empty path (nodes).")
        let result4 = cityGraph2.route(0, 1, in: [:])
        XCTAssertTrue(result4.isEmpty, "No route in empty path (indices).")
    }

    func testBFS1() {
        // Seattle -> Miami
        let result = cityGraph.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.node(at: last.target), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.node(at: first.source), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Seattle to Miami")
        print(cityGraph.nodes(from: result))
    }

    func testBFS2() {
        // Boston -> LA
        let result = cityGraph.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.node(at: last.target), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.node(at: first.source), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Boston to Los Angeles")
        print(cityGraph.nodes(from: result))
    }

    func testBFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph.bfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.node(at: last.target), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.node(at: first.source), "Houston", "Houston is not the start")
        }
        print(cityGraph.nodes(from: result))
    }

    func testBFS4() {
        // Seattle -> Miami
        let result = cityGraph2.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Seattle to Miami")
        print(cityGraph2.nodes(from: result))
    }

    func testBFS5() {
        // Boston -> LA
        let result = cityGraph2.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Boston to Los Angeles")
        print(cityGraph2.nodes(from: result))
    }

    func testBFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.bfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.node(at: last.target), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.node(at: first.source), "Houston", "Houston is not the start")
        }
        print(cityGraph2.nodes(from: result))
    }

    func testRoutes() {
        // New York -> all cities starting with "S"
        let result = cityGraph.routes(from: "New York") { v in
            return v.first == "S"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find any connections between New York and a city starting with S (there is one).")
        XCTAssertEqual(result.count, 2, "Should be 2 cities found starting with S")
        if let last = result.last, let first = result.first {
            let pathOne = cityGraph.nodes(from: last)
            print(pathOne)
            let pathTwo = cityGraph.nodes(from: first)
            print(pathTwo)
            let endCities = [pathOne.last!, pathTwo.last!]
            XCTAssertTrue(endCities.contains("Seattle"), "Should contain a route to Seattle")
            XCTAssertTrue(endCities.contains("San Francisco"), "Should contain a route to San Francisco")
        }
    }

    static var allTests = [
        ("testDFS1", testDFS1),
        ("testDFS2", testDFS2),
        ("testDFS3", testDFS3),
        ("testDFS4", testDFS4),
        ("testDFS5", testDFS5),
        ("testDFS6", testDFS6),
        ("testEmptyDFS", testEmptyDFS),
        ("testEmptyBFS", testEmptyBFS),
        ("testEmptyRoutes", testEmptyRoutes),
        ("testBFS1", testBFS1),
        ("testBFS2", testBFS2),
        ("testBFS3", testBFS3),
        ("testBFS4", testBFS4),
        ("testBFS5", testBFS5),
        ("testBFS6", testBFS6),
        ("testRoutes", testRoutes),
    ]
}
