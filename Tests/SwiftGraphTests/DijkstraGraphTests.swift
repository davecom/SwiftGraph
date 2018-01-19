//
//  DijkstraGraphTests.swift
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

class DijkstraGraphTests: XCTestCase {
    // pg 1016 Liang
    var cityGraph: _WeightedGraph<String, Int> = _WeightedGraph<String, Int>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])

    // 15 largest MSAs in United States as of 2016
    var cityGraph2: _WeightedGraph<String, Int> = _WeightedGraph<String, Int>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1062 Liang
        cityGraph.link("Seattle", to: "Chicago", weight: 2097)
        cityGraph.link("Seattle", to: "Denver", weight: 1331)
        cityGraph.link("Seattle", to: "San Francisco", weight: 807)
        cityGraph.link("San Francisco", to: "Denver", weight: 1267)
        cityGraph.link("San Francisco", to: "Los Angeles", weight: 381)
        cityGraph.link("Los Angeles", to: "Denver", weight: 1015)
        cityGraph.link("Los Angeles", to: "Kansas City", weight: 1663)
        cityGraph.link("Los Angeles", to: "Dallas", weight: 1435)
        cityGraph.link("Denver", to: "Chicago", weight: 1003)
        cityGraph.link("Denver", to: "Kansas City", weight: 599)
        cityGraph.link("Kansas City", to: "Chicago", weight: 533)
        cityGraph.link("Kansas City", to: "New York", weight: 1260)
        cityGraph.link("Kansas City", to: "Atlanta", weight: 864)
        cityGraph.link("Kansas City", to: "Dallas", weight: 496)
        cityGraph.link("Chicago", to: "Boston", weight: 983)
        cityGraph.link("Chicago", to: "New York", weight: 787)
        cityGraph.link("Boston", to: "New York", weight: 214)
        cityGraph.link("Atlanta", to: "New York", weight: 888)
        cityGraph.link("Atlanta", to: "Dallas", weight: 781)
        cityGraph.link("Atlanta", to: "Houston", weight: 810)
        cityGraph.link("Atlanta", to: "Miami", weight: 661)
        cityGraph.link("Houston", to: "Miami", weight: 1187)
        cityGraph.link("Houston", to: "Dallas", weight: 239)
        print(cityGraph.description)

        cityGraph2.link("Seattle", to: "Chicago", weight: 1737)
        cityGraph2.link("Seattle", to: "San Francisco", weight: 678)
        cityGraph2.link("San Francisco", to: "Riverside", weight: 386)
        cityGraph2.link("San Francisco", to: "Los Angeles", weight: 348)
        cityGraph2.link("Los Angeles", to: "Riverside", weight: 50)
        cityGraph2.link("Los Angeles", to: "Phoenix", weight: 357)
        cityGraph2.link("Riverside", to: "Phoenix", weight: 307)
        cityGraph2.link("Riverside", to: "Chicago", weight: 1704)
        cityGraph2.link("Phoenix", to: "Dallas", weight: 887)
        cityGraph2.link("Phoenix", to: "Houston", weight: 1015)
        cityGraph2.link("Dallas", to: "Chicago", weight: 805)
        cityGraph2.link("Dallas", to: "Atlanta", weight: 721)
        cityGraph2.link("Dallas", to: "Houston", weight: 225)
        cityGraph2.link("Houston", to: "Atlanta", weight: 702)
        cityGraph2.link("Houston", to: "Miami", weight: 968)
        cityGraph2.link("Atlanta", to: "Chicago", weight: 588)
        cityGraph2.link("Atlanta", to: "Washington", weight: 543)
        cityGraph2.link("Atlanta", to: "Miami", weight: 604)
        cityGraph2.link("Miami", to: "Washington", weight: 923)
        cityGraph2.link("Chicago", to: "Detroit", weight: 238)
        cityGraph2.link("Detroit", to: "Boston", weight: 613)
        cityGraph2.link("Detroit", to: "Washington", weight: 396)
        cityGraph2.link("Detroit", to: "New York", weight: 482)
        cityGraph2.link("Boston", to: "New York", weight: 190)
        cityGraph2.link("New York", to: "Philadelphia", weight: 81)
        cityGraph2.link("Philadelphia", to: "Washington", weight: 123)
        print(cityGraph2.description)
    }

    func testDijkstra1() {
        // Seattle -> Miami
        let (nameDistance, path): ([String: Int?], [Int: _WeightedEdge<Int>]) = cityGraph.dijkstra(from: "New York", start: 0)
        XCTAssertFalse(nameDistance.isEmpty, "Dijkstra result set is empty.")

        if let temp = nameDistance["San Francisco"] {
            XCTAssertEqual(temp!, 3057, "San Francisco should be 3057 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Los Angeles"] {
            XCTAssertEqual(temp!, 2805, "Los Angeles should be 2805 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Seattle"] {
            XCTAssertEqual(temp!, 2884, "Seattle should be 2884 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Denver"] {
            XCTAssertEqual(temp!, 1790, "Denver should be 1790 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Kansas City"] {
            XCTAssertEqual(temp!, 1260, "Kansas City should be 1260 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Chicago"] {
            XCTAssertEqual(temp!, 787, "Chicago should be 787 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Boston"] {
            XCTAssertEqual(temp!, 214, "Boston should be 214 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Atlanta"] {
            XCTAssertEqual(temp!, 888, "Atlanta should be 888 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Miami"] {
            XCTAssertEqual(temp!, 1549, "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Dallas"] {
            XCTAssertEqual(temp!, 1669, "Dallas should be 1669 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Houston"] {
            XCTAssertEqual(temp!, 1698, "Houston should be 1698 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }

        // path between New York and San Francisco
        let edges: [_WeightedEdge<Int>] = cityGraph.route(from: "New York", to: "San Francisco", in: path)
        let stops: [String] = cityGraph.nodes(from: edges)
        print("\(stops))")
        XCTAssertEqual(stops, ["New York", "Chicago", "Denver", "San Francisco"], "Atlanta should be 888 miles away.")
    }

    func testDijkstra2() {
        let (nameDistance, path): ([String: Int?], [Int: _WeightedEdge<Int>]) = cityGraph.dijkstra(from: "Miami", start: 0)
        XCTAssertFalse(nameDistance.isEmpty, "Dijkstra result set is empty.")

        if let temp = nameDistance["Seattle"] {
            XCTAssertEqual(temp!, 3455, "Seattle should be 3455 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Chicago"] {
            XCTAssertEqual(temp!, 2058, "Chicago should be 2058 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Atlanta"] {
            XCTAssertEqual(temp!, 661, "Atlanta should be 661 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["New York"] {
            XCTAssertEqual(temp!, 1549, "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }

        // path between New York and Seattle
        let edges: [_WeightedEdge<Int>] = cityGraph.route(from: "Miami", to: "San Francisco", in: path)
        let stops: [String] = cityGraph.nodes(from: edges)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Dallas", "Los Angeles", "San Francisco"], "Shortest path to San Francisco is not right.")
    }

    func testDijkstra3() {
        let (nameDistance, path): ([String: Int?], [Int: _WeightedEdge<Int>]) = cityGraph2.dijkstra(from: "Miami", start: 0)
        XCTAssertFalse(nameDistance.isEmpty, "Dijkstra result set is empty.")

        if let temp = nameDistance["Seattle"] {
            XCTAssertEqual(temp!, 2929, "Seattle should be 2929 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Chicago"] {
            XCTAssertEqual(temp!, 1192, "Chicago should be 1192 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["Atlanta"] {
            XCTAssertEqual(temp!, 604, "Atlanta should be 604 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance["New York"] {
            XCTAssertEqual(temp!, 1127, "Miami should be 1127 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }

        // path between New York and Seattle
        let edges: [_WeightedEdge<Int>] = cityGraph2.route(from: "Miami", to: "San Francisco", in: path)
        let stops: [String] = cityGraph2.nodes(from: edges)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Phoenix", "Riverside", "San Francisco"], "Shortest path to San Francisco is not right.")
    }

    func testDijkstra4() {
        var (nameDistance, path): ([Int?], [Int: _WeightedEdge<Int>]) = cityGraph2.dijkstra(from: "Rome", start: 0)
        XCTAssertTrue(nameDistance.isEmpty, "No distance from non-existing node.")
        XCTAssertTrue(path.isEmpty, "No path from non-existing node.")

        (nameDistance, path) = cityGraph2.dijkstra(from: "Miami", start: 0)
        XCTAssertFalse(nameDistance.isEmpty, "Distance exists.")
        XCTAssertFalse(path.isEmpty, "Path exists.")

        let (nameDistance2, path2): ([String: Int?], [Int: _WeightedEdge<Int>]) = cityGraph2.dijkstra(from: "Rome", start: 0)
        XCTAssertTrue(nameDistance2.isEmpty, "No distance from non-existing node in dictionary overload.")
        XCTAssertTrue(path2.isEmpty, "No path from non-existing node in dictionary overload.")

        let node1 = DijkstraNode<Int>(node: 0, distance: 2)
        let node2 = DijkstraNode<Int>(node: 0, distance: 2)
        XCTAssertEqual(node1, node2, "DijkstraNode == operator works correctly.")
    }

    func testRemovalWithDijkstra() {
        var cityGraph3 = cityGraph
        cityGraph3.remove("Kansas City")
        let (nameDistance, path): ([String: Int?], [Int: _WeightedEdge<Int>]) = cityGraph3.dijkstra(from: "Miami", start: 0)

        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }

        let edges: [_WeightedEdge<Int>] = cityGraph3.route(from: "Miami", to: "Chicago", in: path)
        let stops: [String] = cityGraph3.nodes(from: edges)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Atlanta", "New York", "Chicago"], "Shortest path to Chicago is not right.")
    }

    static var allTests = [
        ("testDijksta1", testDijkstra1),
        ("testDijksta2", testDijkstra2),
        ("testDijksta3", testDijkstra3),
        ("testDijksta4", testDijkstra4),
        ("testRemovalWithDijksta", testRemovalWithDijkstra),
    ]
}
