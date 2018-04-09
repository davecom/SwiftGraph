//
//  SwiftGraphTests.swift
//  SwiftGraphTests
//
//  Copyright (c) 2014-2017 David Kopec
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

@testable import SwiftGraph
import XCTest

// Note: All graphs here are immutable because they are classes and mutations
// are happening internally. If we use a struct-based graph instead of a
// class-based one the test doesn't compile because struct methods are `mutating`.
// We are bypassing them with classes (via specific, nonmutating implementations)
// to allow those methods to be used internally by the classes themselves (they
// couldn't be used _internally_ if the protocol specified them as `mutating`
// and a `nonmutating` variant were not provided).

class SwiftGraphTests: XCTestCase {
    func testCitesInverseAfterRemove() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add("Atlanta")
        g.add("New York")
        g.add("Miami")
        g.link("Atlanta", to: "New York")
        g.link("Miami", to: "Atlanta")
        g.link("New York", to: "Miami")
        g.remove("Atlanta")
        XCTAssertEqual(g.neighbors(of: "Miami")!, g.neighbors(of: g.neighbors(of: "New York")![0])!, "Miami and New York Connected bi-directionally")
    }

    func testSequenceTypeAndCollectionType() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add("Atlanta")
        g.add("New York")
        g.add("Miami")
        var tempList: [String] = []
        for v in g {
            tempList.append(v)
        }
        XCTAssertEqual(tempList, ["Atlanta", "New York", "Miami"], "Iterated Successfully")
        XCTAssertEqual(g[1], "New York", "Subscripted Successfully")
    }

    func testCounts() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add("Atlanta")
        g.add("New York")
        g.add("Miami")
        g.link("Atlanta", to: "New York", directed: true)
        g.link("Miami", to: "Atlanta", directed: true)
        g.link("New York", to: "Miami", directed: true)
        g.link("Atlanta", to: "Miami", directed: true)
        XCTAssertEqual(g.nodeCount, 3, "3 total nodes")
        XCTAssertEqual(g.edgeCount, 4, "4 total edges")
        g.remove("Atlanta")
        XCTAssertEqual(g.nodeCount, 2, "2 total nodes")
        XCTAssertEqual(g.edgeCount, 1, "1 total edges")
    }

    func testSubscript() {
        var g: _UnweightedGraph<String> = _UnweightedGraph<String>()
        g.add("Atlanta")
        g.add("New York")
        g.add("Miami")
        XCTAssertEqual(g[0], "Atlanta", "Expected result at node 0")
        XCTAssertEqual(g[2], "Miami", "Expected result at node 2")
    }

    func testVarious() {
        var g: _UnweightedGraph<String> = .init()

        g.add("Atlanta")
        g.add("Miami")
        g.link("Atlanta", to: "Miami", directed: false)
        XCTAssertTrue(g.contains("Atlanta"), "Graph contains added node.")

        let edge = g.edges(of: "Atlanta")!.first!
        XCTAssertTrue(g.contains(edge), "Graph contains added edge.")
        XCTAssertFalse(edge.weighted, "Edge is correctly unweighted.")

        g.remove(edge)
        XCTAssertFalse(g.contains(edge), "Edge was correctly removed.")

        g.link("Lagos", to: "Atlanta")
        XCTAssertNil(g.edges(of: "Lagos"), "Edge is not added for non-existing node.")

        g.link("Atlanta", to: "Miami", directed: false)
        g.unlink("Atlanta", from: "Miami", bidirectional: true)
        g.unlink("Atlanta", from: "Rome", bidirectional: true)

        var wg1 = _WeightedGraph<String, Int>(nodes: ["0", "1"])
        var wg2 = _WeightedGraph<String, Int>(nodes: ["0", "1"])

        XCTAssertEqual(wg1.immutableNodes, wg2.immutableNodes)
        XCTAssertNil(wg1.neighbors(of: "3"), "No neighbors for non-existing node.")

        wg1.remove("3")

        wg1.link(0, 1, weight: 1)
        wg2.link(0, 1, directed: true, weight: 1)
        let weightedEdge = wg1.edges(0).first!
        let anotherWeightedEdge = wg2.edges(0).first!
        wg2.link(0, 1, weight: 1)
        let identicalWeightedEdge = wg2.edges[0][1]
        XCTAssertTrue(wg1.contains(weightedEdge), "Weighted graph correctly adds weighted edge.")
        XCTAssertEqual(weightedEdge, identicalWeightedEdge, "== works as expected on WeightedEdge")

        XCTAssertTrue(wg1.links("0", to: "1"), "Weighted graph correctly checks for existing weighted edge.")
        XCTAssertFalse(wg1.links("0", to: "2"), "Weighted graph correctly checks for non-existing edge.")

        XCTAssertTrue(weightedEdge.weighted, "Edge is correctly weighted.")

        XCTAssertEqual(weightedEdge.description, "0 <1> 1", ".description works as expected.")
        XCTAssertEqual(anotherWeightedEdge.description, "0 1> 1", "directed .description works as expected.")

        wg1.link("3", to: "4", weight: 1)
        XCTAssertNil(wg1.edges(of: "3"), "Weighted edge does not add edges for non-existing nodes.")

        let variadicG = _UnweightedGraph(nodes: "0", "1", "2")
        XCTAssertEqual(variadicG.nodes, ["0", "1", "2"], "Variadic initializer works as expected.")
    }

    func testUnedge() {
        var graph = _UnweightedGraphStruct(nodes: ["0", "1", "2", "3", "4", "5", "6"])
        graph.link("0", to: "1", directed: false)
        graph.link("1", to: "2", directed: false)
        graph.link("2", to: "3", directed: false)
        graph.link("3", to: "2", directed: false)
        graph.link("3", to: "4", directed: false)
        graph.link("4", to: "5", directed: false)
        let edge = graph.edges(of: "2")!.first!
        graph.unlink(2, 3, bidirectional: true)
        graph.unlink("4", from: "5", bidirectional: false)

        XCTAssertFalse(graph.links(2, 3), "Removes edge.")
        XCTAssertFalse(graph.links(3, 2), "Removes edge bidirectionally.")
        XCTAssertFalse(graph.links("4", to: "5"), "Removes edge when bidirectional is false.")
        XCTAssertTrue(graph.links("5", to: "4"), "Persists edge when the other is removed with bidirectional = false.")

        graph.edges[edge.source].removeAll()
        graph.edges[edge.target].removeAll()
        let copy = graph // Must be a struct. Check its type.
        graph.remove(edge)
        XCTAssertEqual(copy, graph, "Leaves the graph intact when an edge is not found within the graph.")

        graph.link("6", to: "5", directed: true)
        graph.remove(graph.edges(of: "6")!.first!)
        XCTAssertFalse(graph.links("6", to: "5"), "Removes directed edge.")
    }

    func testMutatingMethods() {
        var g1 = _UnweightedGraphStruct(nodes: ["0", "1", "2", "3", "4", "5", "6"])
        var g2 = _WeightedGraphStruct<String, Int>(nodes: ["0", "1", "2", "3", "4", "5", "6"])

        g1.add("7")
        XCTAssertTrue(g1.contains("7"), "(Mutating) Adds a node to an unweighted graph.")

        g1.link(0, 1)
        g2.link(0, 1, weight: 1)
        g1.link("2", to: "3")
        g2.link("2", to: "3", weight: 1)

        let e1 = g1.edges[0].first!
        let e2 = g2.edges[0].first!
        XCTAssertTrue(g1.contains(e1), "(Mutating) Adds (indices) an edge to an unweighted graph.")
        XCTAssertTrue(g2.contains(e2), "(Mutating) Adds (indices) an edge to a weighted graph.")

        let e3 = g1.edges(of: "2")!.first!
        let e4 = g2.edges(of: "2")!.first!
        XCTAssertTrue(g1.contains(e3), "(Mutating) Adds (nodes) an edge to an unweighted graph.")
        XCTAssertTrue(g2.contains(e4), "(Mutating) Adds (nodes) an edge to a weighted graph.")

        g1.remove("6")
        XCTAssertFalse(g1.contains("6"), "(Mutating) Removes (node) a node from an unweighted graph.")

        let v1 = g1.node(at: 3)
        g1.remove(at: 3)
        XCTAssertFalse(g1.contains(v1), "(Mutating) Removes (index) a node from an unweighted graph.")

        g1.remove(e1)
        XCTAssertFalse(g1.contains(e1), "(Mutating) Removes an edge from an unweighted graph.")

        g2.unlink(0, 1, bidirectional: true)
        XCTAssertFalse(g2.contains(e2), "(Mutating) Removes an edge from two nodes (indices) from a weighted graph.")

        g2.unlink("2", from: "3", bidirectional: true)
        XCTAssertFalse(g2.contains(e4), "(Mutating) Removes an edge from two nodes (nodes) from a weighted graph.")

        g1.link("10", to: "11", directed: true)
        XCTAssertNil(g1.edges(of: "10"), "(Mutating) Does not add a directed an edge on a non-existing node in an unweighted graph.")

        g2.link("10", to: "11", directed: true, weight: 1)
        XCTAssertNil(g2.edges(of: "10"), "(Mutating) Does not add a directed an edge on a non-existing node in a weighted graph.")
    }

    func testQueue() {
        let q = Queue<Int>()
        q.push(1)
        XCTAssertTrue(q.contains(1), "Adds to the queue.")
        XCTAssertFalse(q.contains(2), "Checks that an elements doesn't exist in the queue.")
        q.push(10)
        XCTAssertEqual(q.count, 2, "Counts queue elements correctly.")
    }

    static var allTests = [
        ("testCitesInverseAfterRemove", testCitesInverseAfterRemove),
        ("testSequenceTypeAndCollectionType", testSequenceTypeAndCollectionType),
        ("testCounts", testCounts),
        ("testSubscript", testSubscript),
        ("testUnedge", testUnedge),
        ("testVarious", testVarious),
        ("testMutatingMethods", testMutatingMethods),
        ("testQueue", testQueue),
    ]
}
