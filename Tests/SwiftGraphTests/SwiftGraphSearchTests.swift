//
//  SwiftGraphSearchTests.swift
//  SwiftGraph
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

import XCTest
@testable import SwiftGraph

class SwiftGraphSearchTests: XCTestCase {
    // pg 1016 Liang
    let cityGraph: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
    
    // 15 largest MSAs in United States as of 2016
    let cityGraph2: UnweightedGraph<String> = UnweightedGraph<String>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Riverside", "Phoenix", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston", "Detroit", "Philadelphia", "Washington"])
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // pg 1016 Liang
        cityGraph.addEdge(from: "Seattle", to: "Chicago")
        cityGraph.addEdge(from: "Seattle", to: "Denver")
        cityGraph.addEdge(from: "Seattle", to: "San Francisco")
        cityGraph.addEdge(from: "San Francisco", to: "Denver")
        cityGraph.addEdge(from: "San Francisco", to: "Los Angeles")
        cityGraph.addEdge(from: "Los Angeles", to: "Denver")
        cityGraph.addEdge(from: "Los Angeles", to: "Kansas City")
        cityGraph.addEdge(from: "Los Angeles", to: "Dallas")
        cityGraph.addEdge(from: "Denver", to: "Chicago")
        cityGraph.addEdge(from: "Denver", to: "Kansas City")
        cityGraph.addEdge(from: "Kansas City", to: "Chicago")
        cityGraph.addEdge(from: "Kansas City", to: "New York")
        cityGraph.addEdge(from: "Kansas City", to: "Atlanta")
        cityGraph.addEdge(from: "Kansas City", to: "Dallas")
        cityGraph.addEdge(from: "Chicago", to: "Boston")
        cityGraph.addEdge(from: "Chicago", to: "New York")
        cityGraph.addEdge(from: "Boston", to: "New York")
        cityGraph.addEdge(from: "Atlanta", to: "New York")
        cityGraph.addEdge(from: "Atlanta", to: "Dallas")
        cityGraph.addEdge(from: "Atlanta", to: "Houston")
        cityGraph.addEdge(from: "Atlanta", to: "Miami")
        cityGraph.addEdge(from: "Houston", to: "Miami")
        cityGraph.addEdge(from: "Houston", to: "Dallas")
        print(cityGraph.description)
        
        cityGraph2.addEdge(from: "Seattle", to: "Chicago")
        cityGraph2.addEdge(from: "Seattle", to: "San Francisco")
        cityGraph2.addEdge(from: "San Francisco", to: "Riverside")
        cityGraph2.addEdge(from: "San Francisco", to: "Los Angeles")
        cityGraph2.addEdge(from: "Los Angeles", to: "Riverside")
        cityGraph2.addEdge(from: "Los Angeles", to: "Phoenix")
        cityGraph2.addEdge(from: "Riverside", to: "Phoenix")
        cityGraph2.addEdge(from: "Riverside", to: "Chicago")
        cityGraph2.addEdge(from: "Phoenix", to: "Dallas")
        cityGraph2.addEdge(from: "Phoenix", to: "Houston")
        cityGraph2.addEdge(from: "Dallas", to: "Chicago")
        cityGraph2.addEdge(from: "Dallas", to: "Atlanta")
        cityGraph2.addEdge(from: "Dallas", to: "Houston")
        cityGraph2.addEdge(from: "Houston", to: "Atlanta")
        cityGraph2.addEdge(from: "Houston", to: "Miami")
        cityGraph2.addEdge(from: "Atlanta", to: "Chicago")
        cityGraph2.addEdge(from: "Atlanta", to: "Washington")
        cityGraph2.addEdge(from: "Atlanta", to: "Miami")
        cityGraph2.addEdge(from: "Miami", to: "Washington")
        cityGraph2.addEdge(from: "Chicago", to: "Detroit")
        cityGraph2.addEdge(from: "Detroit", to: "Boston")
        cityGraph2.addEdge(from: "Detroit", to: "Washington")
        cityGraph2.addEdge(from: "Detroit", to: "New York")
        cityGraph2.addEdge(from: "Boston", to: "New York")
        cityGraph2.addEdge(from: "New York", to: "Philadelphia")
        cityGraph2.addEdge(from: "Philadelphia", to: "Washington")
        print(cityGraph2.description)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDFS1() {
        // Seattle -> Miami
        let result = cityGraph.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(cityGraph.edgesToVertices(edges: result))
    }
    
    func testDFS2() {
        // Boston -> LA
        let result = cityGraph.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(cityGraph.edgesToVertices(edges: result))
    }
    
    func testDFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(cityGraph2.edgesToVertices(edges: result))
    }
    
    func testDFS4() {
        // Seattle -> Miami
        let result = cityGraph2.dfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        print(cityGraph2.edgesToVertices(edges: result))
    }
    
    func testDFS5() {
        // Boston -> LA
        let result = cityGraph2.dfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        print(cityGraph2.edgesToVertices(edges: result))
    }
    
    func testDFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(cityGraph2.edgesToVertices(edges: result))
    }

    func testDFSNotFound() {
        // Houston -> first city starting with "Z"
        let result = cityGraph2.dfs(from: "Houston") { v in
            return v.first == "Z"
        }
        XCTAssertTrue(result.isEmpty, "Found a city starting with Z when there's none.")
        print(cityGraph2.edgesToVertices(edges: result))
    }

    func testDFSWithCycle() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C"])

        let paths = [
            g.dfs(from: "A", to: "C"),
            g.dfs(from: "A", to: "B"),
            g.dfs(from: "B", to: "A"),
            g.dfs(from: "B", to: "C"),
            g.dfs(from: "C", to: "A"),
            g.dfs(from: "C", to: "B"),
        ]

        // Since we don't specify the visit order of the neighbours of a vertex, we can't assure
        // all paths have lenght 2. By now, we are happy only asserting that at least one of the paths
        // is lenght 2. This indicates that we are not prematurely marking as visited the neighbours
        // of the current vertex.
        let atLeastOnePathHasLenght2 = paths.first(where: { $0.count == 2 }) != nil

        XCTAssertTrue(atLeastOnePathHasLenght2, "In a Complete Graph, the dfs must visit all nodes in the same path")
    }

    func testDfsDoesntVisitTwice() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C"])
        var visitLog: [String] = []
        _ = g.dfs(from: "A", goalTest: { (v) -> Bool in
            visitLog.append(v)
            return false
        })
        XCTAssertEqual(visitLog, ["A", "C", "B"])
    }

    func testDfsInCompleteGraphWithGoalTestByIndex() {
        var visited = Array<Bool>.init(repeating: false, count: 200)
        let graph = CompleteGraph.build(withVertices: Array(0...199))
        _ = graph.dfs(fromIndex: 0, goalTest: { i in
            visited[i] = true
            return false
        })
        let numVisitedVertices = visited.filter({ $0 }).count
        XCTAssertEqual(numVisitedVertices, 200, "The DFS must visit all the vertices")
    }

    func testDfsGoalTestOnInitialVertex() {
        var visited = false
        let graph = CompleteGraph.build(withVertices: Array(0...3))
        _ = graph.dfs(fromIndex: 0, goalTest: { i in
            if (i == 0) {
                visited = true
            }
            return true
        })
        XCTAssertTrue(visited, "The DFS must check if the initialVertex is already a goal.")
    }

    func testDfsVisitOrderWithCycle() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C"])
        var visited: [String] = []
        _ = g.dfs(fromIndex: g.indexOfVertex("A")!,
                  goalTest: { i in return false },
                  visitOrder: { $0.sorted(by: { $0.v < $1.v }) },
                  reducer: { e in
                    visited.append(g.vertexAtIndex(e.v))
                    return true
                  }
        )
        XCTAssertEqual(visited, ["C", "B"])
    }

    func testTraverseDfsOnCycle() {
        let g = UnweightedGraph.withCycle( ["A", "B", "C"], directed: true)
        let aIndex = g.indexOfVertex("A")!

        // First vertex is not fed to the reducer
        var visitedCound = 1
        var visitLog = "A"

        let finalVertexIndex = g.traverseDfs(fromIndex: aIndex,
                                             goalTest: { _ in visitedCound == 3},
                                             visitOrder: { $0 },
                                             reducer: {
                                                visitLog += g.vertexAtIndex($0.v)
                                                if $0.v == aIndex {
                                                    visitedCound += 1
                                                }
                                                return true
                                             }
        )
        XCTAssertEqual(finalVertexIndex, aIndex, "The traversal must finish on vertex A")
        XCTAssertEqual(visitLog, "ABCABCA", "The cycle must be traversed twice")
    }

    func testFindAllDfs() {
        // New York -> all cities starting with "S"
        let result = cityGraph.findAllDfs(from: "New York") { v in
            return v.first == "S"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find any connections between New York and a city starting with S (there is one).")
        XCTAssertEqual(result.count, 2, "Should be 2 cities found starting with S")
        if let last = result.last, let first = result.first {
            let pathOne = cityGraph.edgesToVertices(edges: last)
            print(pathOne)
            let pathTwo = cityGraph.edgesToVertices(edges: first)
            print(pathTwo)
            let endCities = [pathOne.last!, pathTwo.last!]
            XCTAssertTrue(endCities.contains("Seattle"), "Should contain a route to Seattle")
            XCTAssertTrue(endCities.contains("San Francisco"), "Should contain a route to San Francisco")
        }
    }

    func testBFS1() {
        // Seattle -> Miami
        let result = cityGraph.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Seattle to Miami")
        print(cityGraph.edgesToVertices(edges: result))
    }
    
    func testBFS2() {
        // Boston -> LA
        let result = cityGraph.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Boston to Los Angeles")
        print(cityGraph.edgesToVertices(edges: result))
    }
    
    func testBFS3() {
        // Houston -> first city starting with "N"
        let result = cityGraph.bfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(cityGraph.edgesToVertices(edges: result))
    }
    
    func testBFS4() {
        // Seattle -> Miami
        let result = cityGraph2.bfs(from: "Seattle", to: "Miami")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Seattle and Miami (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Miami", "Miami not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Seattle", "Seattle is not the start")
        }
        XCTAssertEqual(result.count, 3, "Expect to take 3 edges to get from Seattle to Miami")
        print(cityGraph2.edgesToVertices(edges: result))
    }
    
    func testBFS5() {
        // Boston -> LA
        let result = cityGraph2.bfs(from: "Boston", to: "Los Angeles")
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Boston and Los Angeles (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "Los Angeles", "Los Angeles not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Boston", "Boston is not the start")
        }
        XCTAssertEqual(result.count, 4, "Expect to take 4 edges to get from Boston to Los Angeles")
        print(cityGraph2.edgesToVertices(edges: result))
    }
    
    func testBFS6() {
        // Houston -> first city starting with "N"
        let result = cityGraph2.bfs(from: "Houston") { v in
            return v.first == "N"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find connection between Houston and a city starting with N (there is one).")
        if let last = result.last {
            XCTAssertEqual(cityGraph2.vertexAtIndex(last.v), "New York", "New York not the destination")
        }
        if let first = result.first {
            XCTAssertEqual(cityGraph2.vertexAtIndex(first.u), "Houston", "Houston is not the start")
        }
        print(cityGraph2.edgesToVertices(edges: result))
    }

    func testBFSWithCycle() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C"])

        let paths = [
            g.bfs(from: "A", to: "C"),
            g.bfs(from: "A", to: "B"),
            g.bfs(from: "B", to: "A"),
            g.bfs(from: "B", to: "C"),
            g.bfs(from: "C", to: "A"),
            g.bfs(from: "C", to: "B")
        ]

        let allPathsHavLenght1 = paths.allSatisfy { $0.count == 1 }
        XCTAssertTrue(allPathsHavLenght1, "In a Triangle Graph, the bfs must visit all nodes directly.")
    }

    func testBFSNotFound() {
        // Houston -> first city starting with "Z"
        let result = cityGraph2.bfs(from: "Houston") { v in
            return v.first == "Z"
        }
        XCTAssertTrue(result.isEmpty, "Found a city starting with Z when there's none.")
        print(cityGraph2.edgesToVertices(edges: result))
    }

    func testBfsInCompleteGraphWithGoalTestByIndex() {
        var visited = Array<Bool>.init(repeating: false, count: 200)
        let graph = CompleteGraph.build(withVertices: Array(0...199))
        _ = graph.bfs(fromIndex: 0, goalTest: { i in
            visited[i] = true
            return false
        })
        let numVisitedVertices = visited.filter({ $0 }).count
        XCTAssertEqual(numVisitedVertices, 200, "The BFS must visit all the vertices")
    }

    func testBfsGoalTestOnInitialVertex() {
        var visited = false
        let graph = CompleteGraph.build(withVertices: Array(0...3))
        _ = graph.bfs(fromIndex: 0, goalTest: { i in
            if (i == 0) {
                visited = true
            }
            return true
        })
        XCTAssertTrue(visited, "The BFS must check if the initialVertex is already a goal.")
    }

    func testBfsVisitOrderWithCycle() {
        let g = CompleteGraph.build(withVertices: ["A", "B", "C"])
        var visited: [String] = []
        _ = g.bfs(fromIndex: g.indexOfVertex("A")!,
                  goalTest: { i in return false },
                  visitOrder: { $0.sorted(by: { $0.v < $1.v }) },
                  reducer: { e in
                    visited.append(g.vertexAtIndex(e.v))
                    return true
                  }
        )
        XCTAssertEqual(visited, ["B", "C"])
    }

    func testTraverseBfsOnCycle() {
        let g = UnweightedGraph.withCycle( ["A", "B", "C"], directed: true)
        let aIndex = g.indexOfVertex("A")!

        // First vertex is not fed to the reducer
        var visitedCound = 1
        var visitLog = "A"

        let finalVertexIndex = g.traverseBfs(fromIndex: aIndex,
                                             goalTest: { _ in visitedCound == 3},
                                             visitOrder: { $0 },
                                             reducer: {
                                                visitLog += g.vertexAtIndex($0.v)
                                                if $0.v == aIndex {
                                                    visitedCound += 1
                                                }
                                                return true
        }
        )
        XCTAssertEqual(finalVertexIndex, aIndex, "The traversal must finish on vertex A")
        XCTAssertEqual(visitLog, "ABCABCA", "The cycle must be traversed twice")
    }
    
    func testFindAllBfs() {
        // New York -> all cities starting with "S"
        let result = cityGraph.findAllBfs(from: "New York") { v in
            return v.first == "S"
        }
        XCTAssertFalse(result.isEmpty, "Couldn't find any connections between New York and a city starting with S (there is one).")
        XCTAssertEqual(result.count, 2, "Should be 2 cities found starting with S")
        if let last = result.last, let first = result.first {
            let pathOne = cityGraph.edgesToVertices(edges: last)
            print(pathOne)
            let pathTwo = cityGraph.edgesToVertices(edges: first)
            print(pathTwo)
            let endCities = [pathOne.last!, pathTwo.last!]
            XCTAssertTrue(endCities.contains("Seattle"), "Should contain a route to Seattle")
            XCTAssertTrue(endCities.contains("San Francisco"), "Should contain a route to San Francisco")
        }
    }
}
