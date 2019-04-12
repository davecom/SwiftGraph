//
//  UnionPerformanceTests.swift
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

class UnionTests: XCTestCase {

    func testDisjointUnion() {
        let g1 = UnweightedUniqueElementsGraph<Int>.withPath( Array(1...999))
        let g2 = UnweightedUniqueElementsGraph<Int>.withPath( Array(1000...1999))
        self.measure {
            _ = UnweightedUniqueElementsGraph<Int>.unionOf(g1, g2)
        }
    }

    func testUnionWithSelf() {
        let g = UnweightedUniqueElementsGraph<Int>.withPath( Array(1...999))
        self.measure {
            _ = UnweightedUniqueElementsGraph<Int>.unionOf(g, g, g, g)
        }
    }
}
