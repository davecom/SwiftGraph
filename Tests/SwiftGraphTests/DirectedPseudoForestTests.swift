//
//  DirectedPseudoForestTests.swift
//  SwiftGraph
//
//  Copyright (c) 2020 Ferran Pujol Camins
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
import SwiftCheck
import SwiftGraph

class DirectedPseudoForestTests: XCTestCase {
    func testAll() {
        property("Adding a vertex does not invalidate the pseudoforest") <- forAll { (forest: ArbitraryDirectedPseudoForest<Int, UnweightedEdge>, v: Int) in
            _ = forest.addVertex(v)
            return pseudoForestIsValid(forest)
        }

        property("Adding an edge does not invalidate the pseudoforest") <- forAll { (forest: ArbitraryDirectedPseudoForest<Int, UnweightedEdge>, newEdge: UnweightedEdge) in
            return (forest.vertexCount > 0 && newEdge.u < forest.vertexCount && newEdge.v < forest.vertexCount) ==> {
                forest.addEdge(newEdge)
                return pseudoForestIsValid(forest)
            }
        }
    }
}
