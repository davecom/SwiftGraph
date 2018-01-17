//
//  Commons.swift
//  SwiftGraphTests
//
//  Copyright (c) 2017 David Kopec
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

final class UnweightedEdgeTest: UnweightedEdge {
    init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }

    var u: Int
    var v: Int
    var directed: Bool
}

final class UnweightedGraphTest<Vertex: Hashable>: UnweightedGraph {
    required init() {}

    var edges: [[UnweightedEdgeTest]] = []
    var vertices: [Vertex] = []

    func addEdge(from: Int, to: Int, directed: Bool = false) {
        add(edge: UnweightedEdgeTest(u: from, v: to, directed: directed))
    }

    func addEdge(from: Vertex, to: Vertex, directed: Bool = false) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: UnweightedEdgeTest(u: from, v: to, directed: directed))
    }

    typealias V = Vertex
    typealias E = UnweightedEdgeTest
}

final class WeightedEdgeTest<Weight: Summable>: WeightedEdge {
    init(u: Int, v: Int, directed: Bool, weight: W) {
        self.u = u
        self.v = v
        self.directed = directed
        self.weight = weight
    }

    var u: Int
    var v: Int
    var directed: Bool
    var weight: W

    typealias W = Weight
}

final class WeightedGraphTest<Vertex: Hashable, Weight: Summable>: WeightedGraph {
    required init() {}

    var edges: [[WeightedEdgeTest<Weight>]] = []
    var vertices: [Vertex] = []

    func addEdge(from: Int, to: Int, directed: Bool = false, weight: W) {
        add(edge: WeightedEdgeTest(u: from, v: to, directed: directed, weight: weight))
    }

    func addEdge(from: Vertex, to: Vertex, directed: Bool = false, weight: W) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: WeightedEdgeTest(u: from, v: to, directed: directed, weight: weight))
    }

    typealias V = Vertex
    typealias E = WeightedEdgeTest<Weight>
}

