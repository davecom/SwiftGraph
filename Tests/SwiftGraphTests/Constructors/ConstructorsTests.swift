//
//  ConstructorsTests.swift
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

class ConstructorsTests: XCTestCase {
    func testStarGraphConstructor() {
        let center = 0
        let leafs = Array(1...9)
        let vertices = [center] + leafs

        let g = StarGraph<Int>.build(withCenter: center, andLeafs: leafs)
        XCTAssertEqual(g.vertices.sorted(), vertices, "The built star graph must contain the provided vertices, and only those.")
        for i in leafs {
            XCTAssertEqual(g.neighborsForIndex(i), [center], "All the leaf vertices must be connected to the center, and only to it.")
        }
        XCTAssertEqual(g.neighborsForIndex(center).sorted(), leafs, "The center must be connected to all the leafs, and can't be connected to itself.")
    }

    func testSingletonStarGraphConstructor() {
        let g = StarGraph<Int>.build(withCenter: 0, andLeafs: [])
        XCTAssertEqual(g.vertices, [0], "The trivial star graph must have only one element.")
    }

    func testCompleteGraphConstructor() {
        let vertices = Array(0...9)
        let g = CompleteGraph<Int>.build(withVertices: vertices)
        for i in vertices {
            XCTAssertEqual((g.neighborsForIndex(i) + [i]).sorted(), vertices, "A complete graph must have each vertex connected to all vertices except itself.")
        }
        XCTAssertEqual(g.vertices, vertices, "The built complete graph must contain the provided vertices, and only those.")
    }

    func testEmptyCompleteGraphConstructor() {
        let g = CompleteGraph<Int>.build(withVertices: [])
        XCTAssertEqual(g.edgeCount, 0, "The empty complete graph must contain no edges")
        XCTAssertEqual(g.vertexCount, 0, "The empty complete graph must contain no vertices")
    }

    func testSingletonCompleteGraphConstructor() {
        let g = CompleteGraph<Int>.build(withVertices: [0])
        XCTAssertEqual(g.edgeCount, 0, "The singleton complete graph must contain no edges")
        XCTAssertEqual(g.vertices, [0], "The singleton complete graph must contain one vertex")
    }
}
