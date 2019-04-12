//
//  ConstructorsPerformanceTests.swift
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

class ConstructorsPerformanceTests: XCTestCase {

    struct AnyEquatable<T: Equatable & Codable>: Equatable, Codable {
        let value: T
    }

    func testPathUnweightedGraphConstructor() {
        self.measure {
            _ = UnweightedGraph.withPath( Array(1...999999))
        }
    }

    func testCycleUnweightedGraphConstructor() {
        self.measure {
            _ = UnweightedGraph.withCycle( Array(1...999999))
        }
    }

    func testPathUnweightedUniqueElementsGraphConstructor() {
        let array = Array(1...2999).map({ AnyEquatable(value: $0) })
        self.measure {
            _ = UnweightedUniqueElementsGraph.withPath( array)
        }
    }

    func testPathUnweightedUniqueElementsGraphHashableConstructor() {
        self.measure {
            _ = UnweightedUniqueElementsGraph<Int>.withPath( Array(1...2999))
        }
    }

    func testCycleUnweightedUniqueElementsGraphConstructor() {
        self.measure {
            _ = UnweightedUniqueElementsGraph.withCycle( Array(1...2999))
        }
    }

    func testCycleUniqueElementsHashableConstructor() {
        let array = Array(1...2999).map({ AnyEquatable(value: $0) })
        self.measure {
            _ = UnweightedUniqueElementsGraph.withCycle( array)
        }
    }

    func testStarGraphConstructor() {
        self.measure {
            _ = StarGraph.build(withCenter: 0, andLeafs: Array(1...999999))
        }
    }

    func testCompleteGraphConstructor() {
        self.measure {
            _ = CompleteGraph.build(withVertices: Array(0...1999))
        }
    }
}
