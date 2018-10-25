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
    let starGraph = StarGraph.build(withCenter: 0, andLeafs: Array(1...99999))
    let pathGraph = UnweightedGraph(withPath: Array(0...99999))
    let completeGraph = CompleteGraph.build(withVertices: Array(0...2499))

    func testDfsInStarGraph() {
        self.measure {
            _ = starGraph.dfs(from: 0, goalTest: { _ in false })
        }
    }

    func testBfsInStarGraph() {
        self.measure {
            _ = starGraph.bfs(from: 0, goalTest: { _ in false })
        }
    }

    func testBfsInStarGraphByIndex() {
        self.measure {
            _ = starGraph.bfs(fromIndex: 0, toIndex: -1)
        }
    }

    func testDfsInPath() {
        self.measure {
            _ = pathGraph.dfs(from: 0, goalTest: { _ in false })
        }
    }

    func testDfsInPathByIndex() {
        self.measure {
            _ = pathGraph.dfs(fromIndex: 0, toIndex: -1)
        }
    }

    func testBfsInPath() {
        self.measure {
            _ = pathGraph.bfs(from: 0, goalTest: { _ in false })
        }
    }

    func testDfsInCompleteGraph() {
        self.measure {
            _ = completeGraph.dfs(from: 0, goalTest: { _ in false })
        }
    }

    func testBfsInCompleteGraph() {
        self.measure {
            _ = completeGraph.bfs(from: 0, goalTest: { _ in false })
        }
    }
}
