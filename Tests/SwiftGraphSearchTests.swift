//
//  SwiftGraphSearchTests.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/19/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class SwiftGraphSearchTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1016 Liang
        cityGraph.addEdge("Seattle", to: "Chicago")
        cityGraph.addEdge("Seattle", to: "Denver")
        cityGraph.addEdge("Seattle", to: "San Francisco")
        cityGraph.addEdge("San Francisco", to: "Denver")
        cityGraph.addEdge("San Francisco", to: "Los Angeles")
        cityGraph.addEdge("Los Angeles", to: "Denver")
        cityGraph.addEdge("Los Angeles", to: "Kansas City")
        cityGraph.addEdge("Los Angeles", to: "Dallas")
        cityGraph.addEdge("Denver", to: "Chicago")
        cityGraph.addEdge("Denver", to: "Kansas City")
        cityGraph.addEdge("Kansas City", to: "Chicago")
        cityGraph.addEdge("Kansas City", to: "New York")
        cityGraph.addEdge("Kansas City", to: "Atlanta")
        cityGraph.addEdge("Kansas City", to: "Dallas")
        cityGraph.addEdge("Chicago", to: "Boston")
        cityGraph.addEdge("Chicago", to: "New York")
        cityGraph.addEdge("Boston", to: "New York")
        cityGraph.addEdge("Atlanta", to: "New York")
        cityGraph.addEdge("Atlanta", to: "Dallas")
        cityGraph.addEdge("Atlanta", to: "Houston")
        cityGraph.addEdge("Atlanta", to: "Miami")
        cityGraph.addEdge("Houston", to: "Miami")
        cityGraph.addEdge("Houston", to: "Dallas")
        print(cityGraph.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDFS1() {
        // Seattle -> Miami
        let result = dfs("Seattle", to: "Miami", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(edgesToVertices(result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testDFS2() {
        // Boston -> LA
        let result = dfs("Boston", to: "Los Angeles", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(edgesToVertices(result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testBFS1() {
        // Seattle -> Miami
        let result = bfs("Seattle", to: "Miami", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Seattle to Miami")
        print(edgesToVertices(result, graph: cityGraph))  // not sure why description not called by println
    }
    
    func testBFS2() {
        // Boston -> LA
        let result = bfs("Boston", to: "Los Angeles", graph: cityGraph)
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Boston to Los Angeles")
        print(edgesToVertices(result, graph: cityGraph))  // not sure why description not called by println
    }
    
    /*func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/
    
}