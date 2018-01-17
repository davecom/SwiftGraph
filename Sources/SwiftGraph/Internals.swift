//
//  Internals.swift
//  SwiftGraph
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

internal final class _UnweightedEdge: UnweightedEdge {
    init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }

    var u: Int
    var v: Int
    var directed: Bool
}

internal final class _UnweightedGraph<Vertex: Hashable>: UnweightedGraph {
    required init() {}

    var edges: [[_UnweightedEdge]] = []
    var vertices: [Vertex] = []

    func edge(_ from: Int, to: Int, directed: Bool = false) {
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    func edge(_ from: Vertex, to: Vertex, directed: Bool = false) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    typealias V = Vertex
    typealias E = _UnweightedEdge
}

internal final class _WeightedEdge<Weight: Summable>: WeightedEdge {
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

internal final class _WeightedGraph<Vertex: Hashable, Weight: Summable>: WeightedGraph {
    required init() {}

    var edges: [[_WeightedEdge<Weight>]] = []
    var vertices: [Vertex] = []

    func edge(_ from: Int, to: Int, directed: Bool = false, weight: W) {
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    func edge(_ from: Vertex, to: Vertex, directed: Bool = false, weight: W) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    typealias V = Vertex
    typealias E = _WeightedEdge<Weight>
}
