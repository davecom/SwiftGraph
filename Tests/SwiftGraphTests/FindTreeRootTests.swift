//
//  UnweightedUniqueElementsGraphHashableTests.swift
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

internal extension SwiftGraph.Graph {
    func toDOT(_ graphName: String = "componentsGraph", nodeName: ((Self.V) -> String)? = nil )  -> String {
        let nodeName = nodeName ?? { String(describing: $0) }
        
        var DOTTree = String("digraph \"\(graphName)\" {\n")
        
        self.vertices.forEach { id in
            var neighboursList = String("{ ")
            let allNeighbours = self.edgesForVertex(id)
            
            
            if let neighbours = allNeighbours {
                for (offset, neighbour) in neighbours.enumerated() {
                    let nodeName = nodeName(self[neighbour.v])
                                            
                    neighboursList.append(
                        "\"\(nodeName)\"".appending(
                            offset >= neighbours.count - 1 ? "" : ", "
                        )
                    )
                }
                
                neighboursList.append(" }")
                

                DOTTree = DOTTree.appending("""
                    "\(nodeName(id))" -> \(neighboursList);\n
                """)
            }
        }
        
        DOTTree.append("}")
        return DOTTree
    }
}

class FindTreeRootTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFindTreeRoot() throws {
        let originalGraph = WeightedGraph<String, Float>()
        
        for component in ["topbar", "secondary topbar", "gallery", "toolbar", "captions"] {
            let _ = originalGraph.addVertex(component)
        }
                
        originalGraph.addEdge(fromIndex: 0, toIndex: 1, weight: 1.2, directed: true)
        originalGraph.addEdge(fromIndex: 0, toIndex: 2, weight: 0.5, directed: true)
        originalGraph.addEdge(fromIndex: 0, toIndex: 3, weight: 1.1, directed: true)
        originalGraph.addEdge(fromIndex: 0, toIndex: 4, weight: 1.3, directed: true)
        
        originalGraph.addEdge(fromIndex: 1, toIndex: 0, weight: 1.1, directed: true)
        originalGraph.addEdge(fromIndex: 1, toIndex: 2, weight: 0.5, directed: true)
        originalGraph.addEdge(fromIndex: 1, toIndex: 3, weight: 1.5, directed: true)
        originalGraph.addEdge(fromIndex: 1, toIndex: 4, weight: 2.2, directed: true)

        originalGraph.addEdge(fromIndex: 3, toIndex: 2, weight: 1.0, directed: true)
        originalGraph.addEdge(fromIndex: 3, toIndex: 4, weight: 1.0, directed: true)
        
        assert(originalGraph.findTreeRoot() == nil)
        
        
        let msaOfTopbar = try originalGraph.msa(root: 1)
        
        let msaAsGraph = WeightedGraph<String, Float>(vertices: originalGraph.vertices)
        for edge in msaOfTopbar {
            msaAsGraph.addEdge(edge, directed: true)
        }
        
        print(msaAsGraph.toDOT())
        assert(msaAsGraph.findTreeRoot() == 1)
    }
}
