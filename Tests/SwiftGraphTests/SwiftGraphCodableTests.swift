//
//  SwiftGraphCodableTests.swift
//  SwiftGraph
//
//  Created by Ian Grossberg on 9/14/18.
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

class SwiftGraphCodableTests: XCTestCase {
    var expectedUnweightedGraph: UnweightedGraph<String> {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York")
        g.addEdge(from: "Miami", to: "Atlanta")
        g.addEdge(from: "New York", to: "Miami")
        g.removeVertex("Atlanta")
        return g
    }
    
    let expectedString = """
    {"edges":[[[{"u":0,"v":1,"directed":false}]],[[{"u":1,"v":0,"directed":false}]]],"vertices":["New York","Miami"]}
    """
    
    func testEncodable() {
        let g = expectedUnweightedGraph

        let jsonData: Data
        do {
            jsonData = try JSONEncoder().encode(g)
        } catch {
            XCTFail("JSONEncoder().encode(g) threw: \(error)")
            return
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        XCTAssertEqual(jsonString, expectedString)
    }
    
    func testDecodable() {
        guard let jsonData = expectedString.data(using: .utf8) else {
            XCTFail("Unable to serialize expected JSON string into Data")
            return
        }
        
        let g: UnweightedGraph<String>
        do {
            g = try JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData)
        } catch {
            XCTFail("JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData) threw: \(error)")
            return
        }
        XCTAssertEqual(g.neighborsForVertex("Miami")!, g.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miami and New York Connected bi-directionally")
//        XCTAssertEqual(g, expectedUnweightedGraph)
    }
}

struct SwiftGraphCodableTests_Vertex: Equatable, Hashable, Decodable, Encodable {
    let int: Int
    let string: String
}

struct SwiftGraphCodableTests_Edge: Comparable, Summable, Decodable, Encodable {
    let weight: Int
    
    static func < (lhs: SwiftGraphCodableTests_Edge, rhs: SwiftGraphCodableTests_Edge) -> Bool {
        return lhs.weight < rhs.weight
    }
    
    static func + (lhs: SwiftGraphCodableTests_Edge, rhs: SwiftGraphCodableTests_Edge) -> SwiftGraphCodableTests_Edge {
        return SwiftGraphCodableTests_Edge(weight: lhs.weight + rhs.weight)
    }
}

extension SwiftGraphCodableTests {
    func cityGraph() -> WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge> {
        // pg 1016 Liang
        let result = WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge>(vertices: [
            SwiftGraphCodableTests_Vertex(int: 0, string: "Seattle"),
            SwiftGraphCodableTests_Vertex(int: 1, string: "San Francisco"),
            SwiftGraphCodableTests_Vertex(int: 2, string: "Los Angeles"),
            SwiftGraphCodableTests_Vertex(int: 3, string: "Denver"),
            SwiftGraphCodableTests_Vertex(int: 4, string: "Kansas City"),
            SwiftGraphCodableTests_Vertex(int: 5, string: "Chicago"),
            SwiftGraphCodableTests_Vertex(int: 6, string: "Boston"),
            SwiftGraphCodableTests_Vertex(int: 7, string: "New York"),
            SwiftGraphCodableTests_Vertex(int: 8, string: "Atlanta"),
            SwiftGraphCodableTests_Vertex(int: 9, string: "Miami"),
            SwiftGraphCodableTests_Vertex(int: 10, string: "Dallas"),
            SwiftGraphCodableTests_Vertex(int: 11, string: "Houston")
            ])
        
        let vertexWithName = { (name: String) -> SwiftGraphCodableTests_Vertex in
            return result.immutableVertices.filter({ $0.string == name }).first!
        }
        // pg 1062 Liang
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("Chicago"), weight: SwiftGraphCodableTests_Edge(weight: 2097))
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("Denver"), weight: SwiftGraphCodableTests_Edge(weight: 1331))
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("San Francisco"), weight: SwiftGraphCodableTests_Edge(weight: 807))
        result.addEdge(from: vertexWithName("San Francisco"), to: vertexWithName("Denver"), weight: SwiftGraphCodableTests_Edge(weight: 1267))
        result.addEdge(from: vertexWithName("San Francisco"), to: vertexWithName("Los Angeles"), weight: SwiftGraphCodableTests_Edge(weight: 381))
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Denver"), weight: SwiftGraphCodableTests_Edge(weight: 1015))
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Kansas City"), weight: SwiftGraphCodableTests_Edge(weight: 1663))
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Dallas"), weight: SwiftGraphCodableTests_Edge(weight: 1435))
        result.addEdge(from: vertexWithName("Denver"), to: vertexWithName("Chicago"), weight: SwiftGraphCodableTests_Edge(weight: 1003))
        result.addEdge(from: vertexWithName("Denver"), to: vertexWithName("Kansas City"), weight: SwiftGraphCodableTests_Edge(weight: 599))
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Chicago"), weight: SwiftGraphCodableTests_Edge(weight: 533))
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("New York"), weight: SwiftGraphCodableTests_Edge(weight: 1260))
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Atlanta"), weight: SwiftGraphCodableTests_Edge(weight: 864))
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Dallas"), weight: SwiftGraphCodableTests_Edge(weight: 496))
        result.addEdge(from: vertexWithName("Chicago"), to: vertexWithName("Boston"), weight: SwiftGraphCodableTests_Edge(weight: 983))
        result.addEdge(from: vertexWithName("Chicago"), to: vertexWithName("New York"), weight: SwiftGraphCodableTests_Edge(weight: 787))
        result.addEdge(from: vertexWithName("Boston"), to: vertexWithName("New York"), weight: SwiftGraphCodableTests_Edge(weight: 214))
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("New York"), weight: SwiftGraphCodableTests_Edge(weight: 888))
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Dallas"), weight: SwiftGraphCodableTests_Edge(weight: 781))
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Houston"), weight: SwiftGraphCodableTests_Edge(weight: 810))
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Miami"), weight: SwiftGraphCodableTests_Edge(weight: 661))
        result.addEdge(from: vertexWithName("Houston"), to: vertexWithName("Miami"), weight: SwiftGraphCodableTests_Edge(weight: 1187))
        result.addEdge(from: vertexWithName("Houston"), to: vertexWithName("Dallas"), weight: SwiftGraphCodableTests_Edge(weight: 239))
        
        return result
    }
    
    func cityGraphJSONString() -> String {
        return """
{"edges":[[[{"u":0,"directed":false,"weight":{"weight":2097},"v":5},{"u":0,"directed":false,"weight":{"weight":1331},"v":3},{"u":0,"directed":false,"weight":{"weight":807},"v":1}]],[[{"u":1,"directed":false,"weight":{"weight":807},"v":0},{"u":1,"directed":false,"weight":{"weight":1267},"v":3},{"u":1,"directed":false,"weight":{"weight":381},"v":2}]],[[{"u":2,"directed":false,"weight":{"weight":381},"v":1},{"u":2,"directed":false,"weight":{"weight":1015},"v":3},{"u":2,"directed":false,"weight":{"weight":1663},"v":4},{"u":2,"directed":false,"weight":{"weight":1435},"v":10}]],[[{"u":3,"directed":false,"weight":{"weight":1331},"v":0},{"u":3,"directed":false,"weight":{"weight":1267},"v":1},{"u":3,"directed":false,"weight":{"weight":1015},"v":2},{"u":3,"directed":false,"weight":{"weight":1003},"v":5},{"u":3,"directed":false,"weight":{"weight":599},"v":4}]],[[{"u":4,"directed":false,"weight":{"weight":1663},"v":2},{"u":4,"directed":false,"weight":{"weight":599},"v":3},{"u":4,"directed":false,"weight":{"weight":533},"v":5},{"u":4,"directed":false,"weight":{"weight":1260},"v":7},{"u":4,"directed":false,"weight":{"weight":864},"v":8},{"u":4,"directed":false,"weight":{"weight":496},"v":10}]],[[{"u":5,"directed":false,"weight":{"weight":2097},"v":0},{"u":5,"directed":false,"weight":{"weight":1003},"v":3},{"u":5,"directed":false,"weight":{"weight":533},"v":4},{"u":5,"directed":false,"weight":{"weight":983},"v":6},{"u":5,"directed":false,"weight":{"weight":787},"v":7}]],[[{"u":6,"directed":false,"weight":{"weight":983},"v":5},{"u":6,"directed":false,"weight":{"weight":214},"v":7}]],[[{"u":7,"directed":false,"weight":{"weight":1260},"v":4},{"u":7,"directed":false,"weight":{"weight":787},"v":5},{"u":7,"directed":false,"weight":{"weight":214},"v":6},{"u":7,"directed":false,"weight":{"weight":888},"v":8}]],[[{"u":8,"directed":false,"weight":{"weight":864},"v":4},{"u":8,"directed":false,"weight":{"weight":888},"v":7},{"u":8,"directed":false,"weight":{"weight":781},"v":10},{"u":8,"directed":false,"weight":{"weight":810},"v":11},{"u":8,"directed":false,"weight":{"weight":661},"v":9}]],[[{"u":9,"directed":false,"weight":{"weight":661},"v":8},{"u":9,"directed":false,"weight":{"weight":1187},"v":11}]],[[{"u":10,"directed":false,"weight":{"weight":1435},"v":2},{"u":10,"directed":false,"weight":{"weight":496},"v":4},{"u":10,"directed":false,"weight":{"weight":781},"v":8},{"u":10,"directed":false,"weight":{"weight":239},"v":11}]],[[{"u":11,"directed":false,"weight":{"weight":810},"v":8},{"u":11,"directed":false,"weight":{"weight":1187},"v":9},{"u":11,"directed":false,"weight":{"weight":239},"v":10}]]],"vertices":[{"int":0,"string":"Seattle"},{"int":1,"string":"San Francisco"},{"int":2,"string":"Los Angeles"},{"int":3,"string":"Denver"},{"int":4,"string":"Kansas City"},{"int":5,"string":"Chicago"},{"int":6,"string":"Boston"},{"int":7,"string":"New York"},{"int":8,"string":"Atlanta"},{"int":9,"string":"Miami"},{"int":10,"string":"Dallas"},{"int":11,"string":"Houston"}]}
"""
    }
    
    func validateDijkstra1(cityGraph: WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge>) {
        let vertexWithName = { (name: String) -> SwiftGraphCodableTests_Vertex in
            return cityGraph.immutableVertices.filter({ $0.string == name }).first!
        }
        
        // Seattle -> Miami
        let (distances, pathDict) = cityGraph.dijkstra(root: vertexWithName("New York"), startDistance: SwiftGraphCodableTests_Edge(weight: 0))
        XCTAssertFalse(distances.isEmpty, "Dijkstra result set is empty.")
        
        //create map of distances to city names
        var nameDistance: [SwiftGraphCodableTests_Vertex: SwiftGraphCodableTests_Edge?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
        if let temp = nameDistance[vertexWithName("San Francisco")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 3057), "San Francisco should be 3057 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Los Angeles")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 2805), "Los Angeles should be 2805 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Seattle")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 2884), "Seattle should be 2884 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Denver")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 1790), "Denver should be 1790 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Kansas City")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 1260), "Kansas City should be 1260 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Chicago")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 787), "Chicago should be 787 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Boston")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 214), "Boston should be 214 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Atlanta")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 888), "Atlanta should be 888 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Miami")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 1549), "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Dallas")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 1669), "Dallas should be 1669 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Houston")] {
            XCTAssertEqual(temp!, SwiftGraphCodableTests_Edge(weight: 1698), "Houston should be 1698 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }
        
        //path between New York and San Francisco
        let path: [WeightedEdge<SwiftGraphCodableTests_Edge>] = pathDictToPath(from: cityGraph.indexOfVertex(vertexWithName("New York"))!, to: cityGraph.indexOfVertex(vertexWithName("San Francisco"))!, pathDict: pathDict)
        let stops: [SwiftGraphCodableTests_Vertex] = edgesToVertices(edges: path, graph: cityGraph)
        print("\(stops))")
        XCTAssertEqual(stops, [
            SwiftGraphCodableTests_Vertex(int: 7, string: "New York"),
            SwiftGraphCodableTests_Vertex(int: 5, string: "Chicago"),
            SwiftGraphCodableTests_Vertex(int: 3, string: "Denver"),
            SwiftGraphCodableTests_Vertex(int: 1, string: "San Francisco")
            ], "Atlanta should be 888 miles away.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println
    }
    
    func testComplexWeightedEncodable() {
        let g = self.cityGraph()
        self.validateDijkstra1(cityGraph: g)
        
        let jsonData: Data
        do {
            jsonData = try JSONEncoder().encode(g)
        } catch {
            XCTFail("JSONEncoder().encode(g) threw: \(error)")
            return
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        // TODO: we should probably compare reparsed Dictionarys to be safe
        XCTAssertEqual(jsonString, self.cityGraphJSONString())
    }
    
    func testComplexWeightedDecodable() {
        guard let jsonData = self.cityGraphJSONString().data(using: .utf8) else {
            XCTFail("Unable to serialize expected JSON string into Data")
            return
        }
        
        let g: WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge>
        do {
            g = try JSONDecoder().decode(WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge>.self, from: jsonData)
        } catch {
            XCTFail("JSONDecoder().decode(WeightedGraph<SwiftGraphCodableTests_Vertex, SwiftGraphCodableTests_Edge>.self, from: jsonData) threw: \(error)")
            return
        }
        self.validateDijkstra1(cityGraph: g)
        //        XCTAssertEqual(g, self.cityGraph())
    }
}
