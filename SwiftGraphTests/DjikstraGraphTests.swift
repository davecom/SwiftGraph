//
//  DjikstraGraphTests.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/19/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

import XCTest

class DjikstraGraphTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: WeightedGraph<String, Int> = WeightedGraph<String, Int>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1062 Liang
        cityGraph.addEdge("Seattle", to: "Chicago", weight:2097)
        cityGraph.addEdge("Seattle", to: "Denver", weight:1331)
        cityGraph.addEdge("Seattle", to: "San Francisco", weight:807)
        cityGraph.addEdge("San Francisco", to: "Denver", weight:1267)
        cityGraph.addEdge("San Francisco", to: "Los Angeles", weight:381)
        cityGraph.addEdge("Los Angeles", to: "Denver", weight:1015)
        cityGraph.addEdge("Los Angeles", to: "Kansas City", weight:1663)
        cityGraph.addEdge("Los Angeles", to: "Dallas", weight:1435)
        cityGraph.addEdge("Denver", to: "Chicago", weight:1003)
        cityGraph.addEdge("Denver", to: "Kansas City", weight:599)
        cityGraph.addEdge("Kansas City", to: "Chicago", weight:533)
        cityGraph.addEdge("Kansas City", to: "New York", weight:1260)
        cityGraph.addEdge("Kansas City", to: "Atlanta", weight:864)
        cityGraph.addEdge("Kansas City", to: "Dallas", weight:496)
        cityGraph.addEdge("Chicago", to: "Boston", weight:983)
        cityGraph.addEdge("Chicago", to: "New York", weight:787)
        cityGraph.addEdge("Boston", to: "New York", weight:214)
        cityGraph.addEdge("Atlanta", to: "New York", weight:888)
        cityGraph.addEdge("Atlanta", to: "Dallas", weight:781)
        cityGraph.addEdge("Atlanta", to: "Houston", weight:810)
        cityGraph.addEdge("Atlanta", to: "Miami", weight:661)
        cityGraph.addEdge("Houston", to: "Miami", weight:1187)
        cityGraph.addEdge("Houston", to: "Dallas", weight:239)
        println(cityGraph.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDjikstra1() {
        // Seattle -> Miami
        let (distances, pathDict) = djikstra(cityGraph, "New York")
        XCTAssertFalse(distances.isEmpty, "Djikstra result set is empty.")

        //create map of distances to city names
        var nameDistance: [String: Int?] = distanceArrayToVertexDict(distances, cityGraph)
        if let temp = nameDistance["San Francisco"] {
            XCTAssertEqual(temp!, 3057, "San Francisco should be 3057 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Los Angeles"] {
            XCTAssertEqual(temp!, 2805, "Los Angeles should be 2805 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Seattle"] {
            XCTAssertEqual(temp!, 2884, "Seattle should be 2884 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Denver"] {
            XCTAssertEqual(temp!, 1790, "Denver should be 1790 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Kansas City"] {
            XCTAssertEqual(temp!, 1260, "Kansas City should be 1260 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Chicago"] {
            XCTAssertEqual(temp!, 787, "Chicago should be 787 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Boston"] {
            XCTAssertEqual(temp!, 214, "Boston should be 214 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        XCTAssertNil(nameDistance["New York"]!, "There should be no path to New York.")
        if let temp = nameDistance["Atlanta"] {
            XCTAssertEqual(temp!, 888, "Atlanta should be 888 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Miami"] {
            XCTAssertEqual(temp!, 1549, "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Dallas"] {
            XCTAssertEqual(temp!, 1669, "Dallas should be 1669 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Houston"] {
            XCTAssertEqual(temp!, 1698, "Houston should be 1698 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        for (key, value) in nameDistance {
            println("\(key) : \(value)")
        }
        
        //path between New York and Seattle
        var path: [WeightedEdge] = pathDictToPath(cityGraph.indexOfVertex("New York")!, cityGraph.indexOfVertex("San Francisco")!, pathDict)
        let stops: [String] = edgesToVertices(path, cityGraph)
        println("\(stops))")
        XCTAssertEqual(stops, ["New York", "Chicago", "Denver", "San Francisco"], "Atlanta should be 888 miles away.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println
    }
    
    func testDjikstra2() {
        let (distances, pathDict) = djikstra(cityGraph, "Miami")
        XCTAssertFalse(distances.isEmpty, "Djikstra result set is empty.")
        
        //create map of distances to city names
        var nameDistance: [String: Int?] = distanceArrayToVertexDict(distances, cityGraph)
        if let temp = nameDistance["Seattle"] {
            XCTAssertEqual(temp!, 3455, "Seattle should be 3455 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["Chicago"] {
            XCTAssertEqual(temp!, 2058, "Chicago should be 2058 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        XCTAssertNil(nameDistance["Miami"]!, "There should be no path to Miami.")
        if let temp = nameDistance["Atlanta"] {
            XCTAssertEqual(temp!, 661, "Atlanta should be 661 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        if let temp = nameDistance["New York"] {
            XCTAssertEqual(temp!, 1549, "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using djikstra.")
        }
        for (key, value) in nameDistance {
            println("\(key) : \(value)")
        }
        
        //path between New York and Seattle
        var path: [WeightedEdge] = pathDictToPath(cityGraph.indexOfVertex("Miami")!, cityGraph.indexOfVertex("San Francisco")!, pathDict)
        let stops: [String] = edgesToVertices(path, cityGraph)
        println("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Dallas", "Los Angeles", "San Francisco"], "Atlanta should be 888 miles away.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println

    }
    
    func testRemovalWithDjikstra() {
        var cityGraph2 = cityGraph
        cityGraph2.removeVertex("Kansas City")
        let (distances, pathDict) = djikstra(cityGraph, "Miami")
        var nameDistance: [String: Int?] = distanceArrayToVertexDict(distances, cityGraph)
        var path: [WeightedEdge] = pathDictToPath(cityGraph.indexOfVertex("Miami")!, cityGraph.indexOfVertex("San Francisco")!, pathDict)
        let stops: [String] = edgesToVertices(path, cityGraph)
        println("\(stops))")
        XCTAssertEqual(stops, ["Miami", "Houston", "Dallas", "Los Angeles", "San Francisco"], "Atlanta should be 888 miles away.")

    }
}