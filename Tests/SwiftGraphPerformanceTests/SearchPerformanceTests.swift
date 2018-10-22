//
//  SearchPerformanceTests.swift
//  SwiftGraphTests
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

class SearchPerformanceTests: XCTestCase {
    func testDfsInStarGraph() {
        let g = StarGraph.build(withCenter: 0, andLeafs: Array(1...999999))
        self.measure {
            _ = g.dfs(from: 0, goalTest: { _ in false })
        }
    }

    func testDfsInPath() {
        let g = UnweightedGraph(withPath: Array(0...999999))
        self.measure {
            _ = g.dfs(from: 0, goalTest: { _ in false })
        }
    }

    func testDfsInCompleteGraph() {
        let g = CompleteGraph.build(withVertices: Array(0...2999))
        self.measure {
            _ = g.dfs(from: 0, goalTest: { _ in false })
        }
    }

    static var allTests = [
        ("testDfsInStarGraph", testDfsInStarGraph),
        ("testDfsInPath", testDfsInPath),
        ("testDfsInCompleteGraph", testDfsInCompleteGraph)
    ]
}
