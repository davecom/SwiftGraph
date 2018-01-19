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

@testable import SwiftGraph
import XCTest

class MSTTests: XCTestCase {
    // pg 1016 Liang
    var cityGraph: _WeightedGraph<String, Int> = _WeightedGraph<String, Int>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])

    // 15 largest MSAs in United States as of 2016
    var cityGraph2: _WeightedGraph<String, Int> = _WeightedGraph<String, Int>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])

    let emptyGraph: _WeightedGraph<String, Int> = .init()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1062 Liang
        cityGraph.edge("Seattle", to: "Chicago", weight: 2097)
        cityGraph.edge("Seattle", to: "Denver", weight: 1331)
        cityGraph.edge("Seattle", to: "San Francisco", weight: 807)
        cityGraph.edge("San Francisco", to: "Denver", weight: 1267)
        cityGraph.edge("San Francisco", to: "Los Angeles", weight: 381)
        cityGraph.edge("Los Angeles", to: "Denver", weight: 1015)
        cityGraph.edge("Los Angeles", to: "Kansas City", weight: 1663)
        cityGraph.edge("Los Angeles", to: "Dallas", weight: 1435)
        cityGraph.edge("Denver", to: "Chicago", weight: 1003)
        cityGraph.edge("Denver", to: "Kansas City", weight: 599)
        cityGraph.edge("Kansas City", to: "Chicago", weight: 533)
        cityGraph.edge("Kansas City", to: "New York", weight: 1260)
        cityGraph.edge("Kansas City", to: "Atlanta", weight: 864)
        cityGraph.edge("Kansas City", to: "Dallas", weight: 496)
        cityGraph.edge("Chicago", to: "Boston", weight: 983)
        cityGraph.edge("Chicago", to: "New York", weight: 787)
        cityGraph.edge("Boston", to: "New York", weight: 214)
        cityGraph.edge("Atlanta", to: "New York", weight: 888)
        cityGraph.edge("Atlanta", to: "Dallas", weight: 781)
        cityGraph.edge("Atlanta", to: "Houston", weight: 810)
        cityGraph.edge("Atlanta", to: "Miami", weight: 661)
        cityGraph.edge("Houston", to: "Miami", weight: 1187)
        cityGraph.edge("Houston", to: "Dallas", weight: 239)
        print(cityGraph.description)

        cityGraph2.edge("Seattle", to: "Chicago", weight: 1737)
        cityGraph2.edge("Seattle", to: "San Francisco", weight: 678)
        cityGraph2.edge("San Francisco", to: "Riverside", weight: 386)
        cityGraph2.edge("San Francisco", to: "Los Angeles", weight: 348)
        cityGraph2.edge("Los Angeles", to: "Riverside", weight: 50)
        cityGraph2.edge("Los Angeles", to: "Phoenix", weight: 357)
        cityGraph2.edge("Riverside", to: "Phoenix", weight: 307)
        cityGraph2.edge("Riverside", to: "Chicago", weight: 1704)
        cityGraph2.edge("Phoenix", to: "Dallas", weight: 887)
        cityGraph2.edge("Phoenix", to: "Houston", weight: 1015)
        cityGraph2.edge("Dallas", to: "Chicago", weight: 805)
        cityGraph2.edge("Dallas", to: "Atlanta", weight: 721)
        cityGraph2.edge("Dallas", to: "Houston", weight: 225)
        cityGraph2.edge("Houston", to: "Atlanta", weight: 702)
        cityGraph2.edge("Houston", to: "Miami", weight: 968)
        cityGraph2.edge("Atlanta", to: "Chicago", weight: 588)
        cityGraph2.edge("Atlanta", to: "Washington", weight: 543)
        cityGraph2.edge("Atlanta", to: "Miami", weight: 604)
        cityGraph2.edge("Miami", to: "Washington", weight: 923)
        cityGraph2.edge("Chicago", to: "Detroit", weight: 238)
        cityGraph2.edge("Detroit", to: "Boston", weight: 613)
        cityGraph2.edge("Detroit", to: "Washington", weight: 396)
        cityGraph2.edge("Detroit", to: "New York", weight: 482)
        cityGraph2.edge("Boston", to: "New York", weight: 190)
        cityGraph2.edge("New York", to: "Philadelphia", weight: 81)
        cityGraph2.edge("Philadelphia", to: "Washington", weight: 123)
        print(cityGraph2.description)
    }

    func testMST1() {
        // find the minimum spanning tree
        guard let mst = cityGraph.mst() else {
            XCTFail("Couldn't find an MST for cityGraph")
            return
        }
        // how much does the minimum spanning tree cost?
        guard let totalWeight = cityGraph.weight(of: mst) else {
            XCTFail("Couldn't find the total weight of the MST for cityGraph")
            return
        }
        cityGraph.printmst(mst)
        XCTAssertEqual(mst.count, cityGraph.count - 1, "MST should contain edges between all nodes so count should be # of nodes - 1")
        XCTAssertEqual(totalWeight, 6513, "MST should cost 6513 for cityGraph")
    }

    func testMST2() {
        // find the minimum spanning tree
        guard let mst = cityGraph2.mst() else {
            XCTFail("Couldn't find an MST for cityGraph")
            return
        }
        // how much does the minimum spanning tree cost?
        guard let totalWeight = cityGraph2.weight(of: mst) else {
            XCTFail("Couldn't find the total weight of the MST for cityGraph")
            return
        }
        cityGraph2.printmst(mst)
        XCTAssertEqual(mst.count, cityGraph2.count - 1, "MST should contain edges between all nodes so count should be # of nodes - 1")
        XCTAssertEqual(totalWeight, 5372, "MST should cost 5372 for cityGraph2")
    }

    func testEmpty() {
        XCTAssertNil(emptyGraph.mst(), "Correctly returns nil for empty graph.")
        XCTAssertNil(emptyGraph.weight(of: []), "Correctly returns nil for empty path.")
    }

    static var allTests = [
        ("testMST1", testMST1),
        ("testMST2", testMST2),
        ("testEmpty", testEmpty),
    ]
}
