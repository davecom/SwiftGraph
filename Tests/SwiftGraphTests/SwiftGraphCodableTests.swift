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
        var g: UnweightedGraph<String> = UnweightedGraph<String>()
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
     {"edges":[[{"u":0,"v":1,"directed":false}],[{"u":1,"v":0,"directed":false}]],"vertices":["New York","Miami"]}
     """
    
    func testEncodableDecodable() {
        let g = expectedUnweightedGraph
        
        do {
            _ = try JSONEncoder().encode(g)
        } catch {
            XCTFail("JSONEncoder().encode(g) threw: \(error)")
            return
        }

        guard let jsonData2 = expectedString.data(using: .utf8) else {
            XCTFail("Unable to serialize expected JSON string into Data")
            return
        }
        
        let g2: UnweightedGraph<String>
        do {
            g2 = try JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData2)
        } catch {
            XCTFail("JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData2) threw: \(error)")
            return
        }
        XCTAssertEqual(g2.neighborsForVertex("Miami")!, g2.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miami and New York Connected bi-directionally")
        //        XCTAssertEqual(g, expectedUnweightedGraph)
        let jsonData3 = try! JSONEncoder().encode(g2)
        let g3: UnweightedGraph<String>
        do {
            g3 = try JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData3)
        } catch {
            XCTFail("JSONDecoder().decode(UnweightedGraph<String>.self, from: jsonData3) threw: \(error)")
            return
        }
        XCTAssertEqual(g3.neighborsForVertex("Miami")!, g3.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miami and New York Connected bi-directionally")
    }
}

struct SwiftGraphCodableTests_Vertex: Equatable, Hashable, Decodable, Encodable {
    let int: Int
    let string: String
}

extension SwiftGraphCodableTests {
    func cityGraph() -> WeightedGraph<SwiftGraphCodableTests_Vertex, Int> {
        // pg 1016 Liang
        let result = WeightedGraph<SwiftGraphCodableTests_Vertex, Int>(vertices: [
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
            return result.vertices.filter({ $0.string == name }).first!
        }
        // pg 1062 Liang
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("Chicago"), weight: 2097)
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("Denver"), weight: 1331)
        result.addEdge(from: vertexWithName("Seattle"), to: vertexWithName("San Francisco"), weight: 807)
        result.addEdge(from: vertexWithName("San Francisco"), to: vertexWithName("Denver"), weight: 1267)
        result.addEdge(from: vertexWithName("San Francisco"), to: vertexWithName("Los Angeles"), weight: 381)
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Denver"), weight: 1015)
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Kansas City"), weight: 1663)
        result.addEdge(from: vertexWithName("Los Angeles"), to: vertexWithName("Dallas"), weight: 1435)
        result.addEdge(from: vertexWithName("Denver"), to: vertexWithName("Chicago"), weight: 1003)
        result.addEdge(from: vertexWithName("Denver"), to: vertexWithName("Kansas City"), weight: 599)
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Chicago"), weight: 533)
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("New York"), weight: 1260)
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Atlanta"), weight: 864)
        result.addEdge(from: vertexWithName("Kansas City"), to: vertexWithName("Dallas"), weight: 496)
        result.addEdge(from: vertexWithName("Chicago"), to: vertexWithName("Boston"), weight: 983)
        result.addEdge(from: vertexWithName("Chicago"), to: vertexWithName("New York"), weight: 787)
        result.addEdge(from: vertexWithName("Boston"), to: vertexWithName("New York"), weight: 214)
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("New York"), weight: 888)
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Dallas"), weight: 781)
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Houston"), weight: 810)
        result.addEdge(from: vertexWithName("Atlanta"), to: vertexWithName("Miami"), weight: 661)
        result.addEdge(from: vertexWithName("Houston"), to: vertexWithName("Miami"), weight: 1187)
        result.addEdge(from: vertexWithName("Houston"), to: vertexWithName("Dallas"), weight: 239)
        
        return result
    }
    
    
    func validateDijkstra1(cityGraph: WeightedGraph<SwiftGraphCodableTests_Vertex, Int>) {
        let vertexWithName = { (name: String) -> SwiftGraphCodableTests_Vertex in
            return cityGraph.vertices.filter({ $0.string == name }).first!
        }
        
        // Seattle -> Miami
        let (distances, pathDict) = cityGraph.dijkstra(root: vertexWithName("New York"), startDistance: 0)
        XCTAssertFalse(distances.isEmpty, "Dijkstra result set is empty.")
        
        //create map of distances to city names
        let nameDistance: [SwiftGraphCodableTests_Vertex: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
        if let temp = nameDistance[vertexWithName("San Francisco")] {
            XCTAssertEqual(temp!, 3057, "San Francisco should be 3057 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Los Angeles")] {
            XCTAssertEqual(temp!, 2805, "Los Angeles should be 2805 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Seattle")] {
            XCTAssertEqual(temp!, 2884, "Seattle should be 2884 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Denver")] {
            XCTAssertEqual(temp!, 1790, "Denver should be 1790 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Kansas City")] {
            XCTAssertEqual(temp!, 1260, "Kansas City should be 1260 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Chicago")] {
            XCTAssertEqual(temp!, 787, "Chicago should be 787 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Boston")] {
            XCTAssertEqual(temp!, 214, "Boston should be 214 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Atlanta")] {
            XCTAssertEqual(temp!, 888, "Atlanta should be 888 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Miami")] {
            XCTAssertEqual(temp!, 1549, "Miami should be 1549 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Dallas")] {
            XCTAssertEqual(temp!, 1669, "Dallas should be 1669 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        if let temp = nameDistance[vertexWithName("Houston")] {
            XCTAssertEqual(temp!, 1698, "Houston should be 1698 miles away.")
        } else {
            XCTFail("Failed to find distance to city in graph using Dijkstra.")
        }
        for (key, value) in nameDistance {
            print("\(key) : \(String(describing: value))")
        }
        
        //path between New York and San Francisco
        let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex(vertexWithName("New York"))!, to: cityGraph.indexOfVertex(vertexWithName("San Francisco"))!, pathDict: pathDict)
        let stops: [SwiftGraphCodableTests_Vertex] = cityGraph.edgesToVertices(edges: path)
        print("\(stops))")
        XCTAssertEqual(stops, [
            SwiftGraphCodableTests_Vertex(int: 7, string: "New York"),
            SwiftGraphCodableTests_Vertex(int: 5, string: "Chicago"),
            SwiftGraphCodableTests_Vertex(int: 3, string: "Denver"),
            SwiftGraphCodableTests_Vertex(int: 1, string: "San Francisco")
            ], "Atlanta should be 888 miles away.")
        //println(edgesToVertices(result, cityGraph))  // not sure why description not called by println
    }
    
    func testComplexWeightedEncodableDecodable() {
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
        guard let jsonData2 = jsonString?.data(using: .utf8) else {
            XCTFail("Unable to serialize expected JSON string into Data")
            return
        }
        
        let g2: WeightedGraph<SwiftGraphCodableTests_Vertex, Int>
        do {
            g2 = try JSONDecoder().decode(WeightedGraph<SwiftGraphCodableTests_Vertex, Int>.self, from: jsonData2)
        } catch {
            XCTFail("JSONDecoder().decode(WeightedGraph<SwiftGraphCodableTests_Vertex, Int>.self, from: jsonData) threw: \(error)")
            return
        }
        self.validateDijkstra1(cityGraph: g2)
        //        XCTAssertEqual(g, self.cityGraph())
    }
}
