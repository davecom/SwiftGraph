//
//  GraphEqualityTests.swift
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

fileprivate extension Graph {
    fileprivate func addEdge(from: Int, to: Int, directed: Bool = false) {
        addEdge(UnweightedEdge(u: from, v: to, directed: directed))
    }
    
    fileprivate func addEdge(from: V, to: V, directed: Bool = false) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                addEdge(UnweightedEdge(u: u, v: v, directed: directed))
            }
        }
    }
}

class GraphEqualityTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReflexivity() {
        let g = Graph<String>()
        XCTAssert(g == g, "Expected empty graph to be equal to itself, but equality check failed")
        
        _ = g.addVertex("A");
        _ = g.addVertex("B");
        XCTAssert(g == g, "Expected graph without edges to be equal to itself, but equality check failed")
        
        g.addEdge(from: "A", to: "B")
        XCTAssert(g == g, "Expected graph to be equal to itself, but equality check failed")
    }
    
    func testEqualityAndSimmetry() {
        let g1 = Graph<String>()
        let g2 = Graph<String>()
        XCTAssert(g1 == g2, "Expected empty graphs to be equal, but equality check failed")
        XCTAssert(g2 == g1, "Expected empty graphs to be simmetrically equal, but equality check failed")
        
        _ = g1.addVertex("A")
        _ = g1.addVertex("B")
        _ = g2.addVertex("A")
        _ = g2.addVertex("B")
        XCTAssert(g1 == g2, "Expected graphs without edges to be equal, but equality check failed")
        XCTAssert(g2 == g1, "Expected graphs without edges to be simmetrically equal, but equality check failed")
        
        g1.addEdge(from: "A", to: "B")
        g2.addEdge(from: "A", to: "B")
        XCTAssert(g1 == g2, "Expected graphs to be equal, but equality check failed")
        XCTAssert(g2 == g1, "Expected graphs to be simmetrically equal, but equality check failed")
    }
    
    func testEqualityFailWhenVerticesDifference() {
        var g1: Graph<String>
        var g2: Graph<String>
    
        g1 = Graph<String>(vertices:["A"])
        g2 = Graph<String>()
        XCTAssert(g1 != g2, "Expected empty graph to be different to non-empty graph, but equality check succeeded")
        
        g1 = Graph<String>(vertices:["A", "B"])
        g2 = Graph<String>(vertices:["A"])
        XCTAssert(g1 != g2, "Expected graphs with different number of vertices to be different, but equality check succeeded")
        
        g1 = Graph<String>(vertices:["A", "B"])
        g2 = Graph<String>(vertices:["A", "C"])
        XCTAssert(g1 != g2, "Expected graphs with different vertices sets to be different, but equality check succeeded")
    }

    func testEqualityFailWhenEdgesDifference() {
        let g1 = Graph<String>(vertices:["A", "B", "C"])
        let g2 = Graph<String>(vertices:["A", "B", "C"])
        
        g1.addEdge(from: "A", to: "B")
        XCTAssert(g1 != g2, "Expected graph with no edges to be different to graph with edges, but equality check succeeded")
        
        g1.addEdge(from: "A", to: "B")
        g1.addEdge(from: "A", to: "C")
        g2.addEdge(from: "A", to: "B")
        XCTAssert(g1 != g2, "Expected graphs with different number of edges to be different, but equality check succeeded")
        
        g1.addEdge(from: "A", to: "B")
        g2.addEdge(from: "A", to: "C")
        XCTAssert(g1 != g2, "Expected graphs with different edges sets to be different, but equality check succeeded")
        
        XCTAssert(g1 != g2, "Expected graphs to be different, but equality check succeeded")
    }
    
    func testEqualityWithRepeatedVertices() {
        let g1 = Graph<String>(vertices:["A", "A", "A"])
        g1.addEdge(from: 0, to: 1)
        
        let g2 = Graph<String>(vertices:["A", "A", "A"])
        g2.addEdge(from: 1, to: 2)
        XCTAssert(g1 != g2, "Expected graphs with different edges to be different, but equality check succeeded")
    }

    static var allTests = [
        ("testReflexivity", testReflexivity),
        ("testEqualityAndSimmetry", testEqualityAndSimmetry),
        ("testEqualityFailWhenVerticesDifference", testEqualityFailWhenVerticesDifference),
        ("testEqualityFailWhenEdgesDifference", testEqualityFailWhenEdgesDifference),
        ("testEqualityWithRepeatedVertices", testEqualityWithRepeatedVertices)
    ]
}
