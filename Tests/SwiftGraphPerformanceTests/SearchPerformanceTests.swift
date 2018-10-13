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
    func testOldDfsInFlatGraph() {
        let g = generateFlatGraph(ofSize: 1000000)
        self.measure {
            _ = g.referneceDfs(from: 0, goalTest: { _ in false })
        }
    }

    func testNewDfsInFlatGraph() {
        let g = generateFlatGraph(ofSize: 1000000)
        self.measure {
            _ = g.dfs(from: 0, goalTest: { _ in false })
        }
    }
}
