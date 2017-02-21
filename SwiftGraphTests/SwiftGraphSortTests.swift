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
@testable import SwiftGraph

class SwiftGraphSortTests: XCTestCase {
    // pg 1016 Liang
    let dressDAG: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["undershorts", "socks", "pants", "shoes", "watch", "belt", "shirt", "tie", "jacket"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1016 Liang
        dressDAG.addEdge(from: "undershorts", to: "shoes", directed: true)
        dressDAG.addEdge(from: "pants", to: "shoes", directed: true)
        dressDAG.addEdge(from: "socks", to: "shoes", directed: true)
        dressDAG.addEdge(from: "undershorts", to: "pants", directed: true)
        dressDAG.addEdge(from: "pants", to: "belt", directed: true)
        dressDAG.addEdge(from: "belt", to: "jacket", directed: true)
        dressDAG.addEdge(from: "shirt", to: "tie", directed: true)
        dressDAG.addEdge(from: "shirt", to: "belt", directed: true)
        dressDAG.addEdge(from: "tie", to: "jacket", directed: true)
        print(dressDAG)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDAG() {
        XCTAssertTrue(dressDAG.isDAG, "dressDAG is a DAG")
    }
    
    func testTopologicalSort() {
        // Seattle -> Miami
        guard let result = dressDAG.topologicalSort() else {
            XCTFail("dressDAG could not be sorted.")
            return
        }
        print(result)
        XCTAssertEqual(result.count, 9, "All items in sort.")
    }
    
}
