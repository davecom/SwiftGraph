//
//  MSTTests.swift
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

class MSTTests: XCTestCase {
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
    
    func testMST1() {
        // find the minimum spanning tree
        guard let mst = cityGraph.mst() else {
            XCTFail("Couldn't find an MST for cityGraph")
            return
        }
        // how much does the minimum spanning tree cost?
        guard let totalWeight = totalWeight(mst) else {
            XCTFail("Couldn't find the total weight of the MST for cityGraph")
            return
        }
        printMST(edges: mst, graph: cityGraph)
        XCTAssertEqual(mst.count, cityGraph.count - 1, "MST should contain edges between all vertices so count should be # of vertices - 1")
        XCTAssertEqual(totalWeight, 6513, "MST should cost 6513 for cityGraph")
    }
    
    func testMST2() {
        // find the minimum spanning tree
        guard let mst = cityGraph2.mst() else {
            XCTFail("Couldn't find an MST for cityGraph")
            return
        }
        // how much does the minimum spanning tree cost?
        guard let totalWeight = totalWeight(mst) else {
            XCTFail("Couldn't find the total weight of the MST for cityGraph")
            return
        }
        printMST(edges: mst, graph: cityGraph2)
        XCTAssertEqual(mst.count, cityGraph2.count - 1, "MST should contain edges between all vertices so count should be # of vertices - 1")
        XCTAssertEqual(totalWeight, 5372, "MST should cost 5372 for cityGraph2")
    }
}
