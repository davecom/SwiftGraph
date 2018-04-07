//
//  WeightedGraphEqualityTests.swift
//  SwiftGraph
//
//  Copyright (c) 2018 Ferran Pujol Camins
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

class WeightedGraphEqualityTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReflexivity() {
        let g = WeightedGraph<String, Double>(vertices:["A", "B"])
        g.addEdge(from: "A", to: "B", weight: 3)
        XCTAssert(g == g, "Expected graph to be equal to itself, but equality check failed")
    }
    
    func testEqualityAndSimmetry() {
        let g1 = WeightedGraph<String, Double>(vertices:["A", "B"])
        let g2 = WeightedGraph<String, Double>(vertices:["A", "B"])
        
        g1.addEdge(from: "A", to: "B", weight: 1)
        g2.addEdge(from: "A", to: "B", weight: 1)
        XCTAssert(g1 == g2, "Expected graphs to be equal, but equality check failed")
        XCTAssert(g2 == g1, "Expected graphs to be simmetrically equal, but equality check failed")
        
        g2.removeAllEdges(from: "A", to: "B", bidirectional: true)
        g2.addEdge(from: "A", to: "B", weight: 2)
        XCTAssert(g1 == g2, "Expected graphs to be different, but equality check succeeded")
    }

    static var allTests = [
        ("testReflexivity", testReflexivity),
        ("testEqualityAndSimmetry", testEqualityAndSimmetry),
    ]
}
