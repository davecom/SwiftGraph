//
//  UniqueElementsGraphContainerEdgeTests.swift
//  SwiftGraph
//
//  Copyright (c) 2019 Ferran Pujol Camins
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

class UniqueElementsGraphContainerEdgeTests: XCTestCase {

    func testExample() {
        let g = UniqueElementsGraphContainerEdge<String, String>(
            vertices: ["A", "B", "C"]
        )
        g.addEdge(ContainerEdge<String>(u: 0, v: 1, value: "AB"))
        g.addEdge(ContainerEdge<String>(u: 1, v: 2, value: "BC"))
        g.addEdge(ContainerEdge<String>(u: 0, v: 1, value: "AB2"))
        g.addEdge(ContainerEdge<String>(u: 1, v: 2, value: "BC"))

        XCTAssertEqual(g.edgeCount, 3, "Wrong number of edges.")
        XCTAssertTrue(arraysHaveSameElements(
            g.values(from: 0, to: 1),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the union.")
        XCTAssertTrue(arraysHaveSameElements(
            g.values(from: 1, to: 2),
            ["BC"]
        ), "Duplicated edge 'BC' must appear only once.")
    }
}
