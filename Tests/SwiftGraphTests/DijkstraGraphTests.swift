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

import XCTest
@testable import SwiftGraph

class DijkstraGraphTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: WeightedGraph<String, Int> = WeightedGraph<String, Int>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    // 15 largest MSAs in United States as of 2016
    let cityGraph2: WeightedGraph<String, Int> = WeightedGraph<String, Int>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1062 Liang
        cityGraph.addEdge(from: "Seattle", to:"Chicago", weight:2097)
        cityGraph.addEdge(from: "Seattle", to: "Denver", weight:1331)
        cityGraph.addEdge(from: "Seattle", to: "San Francisco", weight:807)
        cityGraph.addEdge(from: "San Francisco", to: "Denver", weight:1267)
        cityGraph.addEdge(from: "San Francisco", to: "Los Angeles", weight:381)
        cityGraph.addEdge(from: "Los Angeles", to: "Denver", weight:1015)
        cityGraph.addEdge(from: "Los Angeles", to: "Kansas City", weight:1663)
        cityGraph.addEdge(from: "Los Angeles", to: "Dallas", weight:1435)
        cityGraph.addEdge(from: "Denver", to: "Chicago", weight:1003)
        cityGraph.addEdge(from: "Denver", to: "Kansas City", weight:599)
        cityGraph.addEdge(from: "Kansas City", to: "Chicago", weight:533)
        cityGraph.addEdge(from: "Kansas City", to: "New York", weight:1260)
        cityGraph.addEdge(from: "Kansas City", to: "Atlanta", weight:864)
        cityGraph.addEdge(from: "Kansas City", to: "Dallas", weight:496)
        cityGraph.addEdge(from: "Chicago", to: "Boston", weight:983)
        cityGraph.addEdge(from: "Chicago", to: "New York", weight:787)
        cityGraph.addEdge(from: "Boston", to: "New York", weight:214)
        cityGraph.addEdge(from: "Atlanta", to: "New York", weight:888)
        cityGraph.addEdge(from: "Atlanta", to: "Dallas", weight:781)
        cityGraph.addEdge(from: "Atlanta", to: "Houston", weight:810)
        cityGraph.addEdge(from: "Atlanta", to: "Miami", weight:661)
        cityGraph.addEdge(from: "Houston", to: "Miami", weight:1187)
        cityGraph.addEdge(from: "Houston", to: "Dallas", weight:239)
        print(cityGraph.description)
        
        cityGraph2.addEdge(from: "Seattle", to: "Chicago", weight: 1737)
        cityGraph2.addEdge(from: "Seattle", to: "San Francisco", weight: 678)
        cityGraph2.addEdge(from: "San Francisco", to: "Riverside", weight: 386)
        cityGraph2.addEdge(from: "San Francisco", to: "Los Angeles", weight: 348)
        cityGraph2.addEdge(from: "Los Angeles", to: "Riverside", weight: 50)
        cityGraph2.addEdge(from: "Los Angeles", to: "Phoenix", weight: 357)
        cityGraph2.addEdge(from: "Riverside", to: "Phoenix", weight: 307)
        cityGraph2.addEdge(from: "Riverside", to: "Chicago", weight: 1704)
        cityGraph2.addEdge(from: "Phoenix", to: "Dallas", weight: 887)
        cityGraph2.addEdge(from: "Phoenix", to: "Houston", weight: 1015)
        cityGraph2.addEdge(from: "Dallas", to: "Chicago", weight: 805)
        cityGraph2.addEdge(from: "Dallas", to: "Atlanta", weight: 721)
        cityGraph2.addEdge(from: "Dallas", to: "Houston", weight: 225)
        cityGraph2.addEdge(from: "Houston", to: "Atlanta", weight: 702)
        cityGraph2.addEdge(from: "Houston", to: "Miami", weight: 968)
        cityGraph2.addEdge(from: "Atlanta", to: "Chicago", weight: 588)
        cityGraph2.addEdge(from: "Atlanta", to: "Washington", weight: 543)
        cityGraph2.addEdge(from: "Atlanta", to: "Miami", weight: 604)
        cityGraph2.addEdge(from: "Miami", to: "Washington", weight: 923)
        cityGraph2.addEdge(from: "Chicago", to: "Detroit", weight: 238)
        cityGraph2.addEdge(from: "Detroit", to: "Boston", weight: 613)
        cityGraph2.addEdge(from: "Detroit", to: "Washington", weight: 396)
        cityGraph2.addEdge(from: "Detroit", to: "New York", weight: 482)
        cityGraph2.addEdge(from: "Boston", to: "New York", weight: 190)
        cityGraph2.addEdge(from: "New York", to: "Philadelphia", weight: 81)
        cityGraph2.addEdge(from: "Philadelphia", to: "Washington", weight: 123)
        print(cityGraph2.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDijkstra1() {
        // Seattle -> Miami
        let (distances, pathDict) = cityGraph.dijkstra(root: "New York", startDistance: 0)
        XCTAssertFalse(distances.isEmpty, "Dijkstra result set is empty.")

        //create map of distances to city names
        let nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
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
        
        //path between New York and San Francisco
        let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex("New York")!, to: cityGraph.indexOfVertex("San Francisco")!, pathDict: pathDict)
        let stops: [String] = cityGraph.edgesToVertices(edges: path)
        print("\(stops))")
        XCTAssertEqual(stops, ["New York", "Chicago", "Denver", "San Francisco"], "Atlanta should be 888 miles away.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println
    }
    
    func testDijkstra2() {
        let (distances, pathDict) = cityGraph.dijkstra(root: "Miami", startDistance: 0)
        XCTAssertFalse(distances.isEmpty, "Dijkstra result set is empty.")
        
        //create map of distances to city names
        let nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
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
        
        //path between New York and Seattle
        let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex("Miami")!, to: cityGraph.indexOfVertex("San Francisco")!, pathDict: pathDict)
        let stops: [String] = cityGraph.edgesToVertices(edges: path)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Dallas", "Los Angeles", "San Francisco"], "Shortest path to San Francisco is not right.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println

    }
    
    func testDijkstra3() {
        let (distances, pathDict) = cityGraph2.dijkstra(root: "Miami", startDistance: 0)
        XCTAssertFalse(distances.isEmpty, "Dijkstra result set is empty.")
        
        //create map of distances to city names
        let nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph2)
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
        
        //path between New York and Seattle
        let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph2.indexOfVertex("Miami")!, to: cityGraph2.indexOfVertex("San Francisco")!, pathDict: pathDict)
        let stops: [String] = cityGraph2.edgesToVertices(edges: path)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Phoenix", "Riverside", "San Francisco"], "Shortest path to San Francisco is not right.")
        //println(edgesToVertices(result, cityGraph2))  // not sure why description not called by println
        
    }
    
    func testRemovalWithDijkstra() {
        var cityGraph3 = cityGraph
        cityGraph3.removeVertex("Kansas City")
        let (distances, pathDict) = cityGraph3.dijkstra(root: "Miami", startDistance: 0)
        let nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph3)
        
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }
        
        let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex("Miami")!, to: cityGraph3.indexOfVertex("Chicago")!, pathDict: pathDict)
        let stops: [String] = cityGraph3.edgesToVertices(edges: path)
        print("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Atlanta", "New York", "Chicago"], "Shortest path to Chicago is not right.")

    }
}
