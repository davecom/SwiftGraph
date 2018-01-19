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

// swiftlint:disable type_name

internal final class _UnweightedEdge: UnweightedEdge {
    init(source: Int, target: Int, directed: Bool) {
        self.source = source
        self.target = target
        self.directed = directed
    }

    var source: Int
    var target: Int
    let directed: Bool
}

internal final class _WeightedEdge<Weight: Summable>: WeightedEdge {
    init(source: Int, target: Int, directed: Bool, weight: W) {
        self.source = source
        self.target = target
        self.directed = directed
        self.weight = weight
    }

    var source: Int
    var target: Int
    let directed: Bool
    let weight: W

    typealias W = Weight
}

internal final class _UnweightedGraph<Node: Hashable>: UnweightedGraph {
    required init() {}

    var edges: [[_UnweightedEdge]] = []
    var nodes: [Node] = []

    func edge(_ from: Int, to: Int, directed: Bool = false) {
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    func edge(_ from: Node, to: Node, directed: Bool = false) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    typealias N = Node
    typealias E = _UnweightedEdge
}

internal final class _WeightedGraph<Node: Hashable, Weight: Summable>: WeightedGraph {
    required init() {}

    var edges: [[_WeightedEdge<Weight>]] = []
    var nodes: [Node] = []

    func edge(_ from: Int, to: Int, directed: Bool = false, weight: W) {
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    func edge(_ from: Node, to: Node, directed: Bool = false, weight: W) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    typealias N = Node
    typealias E = _WeightedEdge<Weight>
}

internal struct _UnweightedGraphStruct<Node: Hashable>: UnweightedGraph {
    var edges: [[_UnweightedEdge]] = []
    var nodes: [Node] = []

    mutating func edge(_ from: Int, to: Int, directed: Bool = false) {
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    mutating func edge(_ from: Node, to: Node, directed: Bool = false) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _UnweightedEdge(u: from, v: to, directed: directed))
    }

    typealias N = Node
    typealias E = _UnweightedEdge
}

internal struct _WeightedGraphStruct<Node: Hashable, Weight: Summable>: WeightedGraph {
    var edges: [[_WeightedEdge<Weight>]] = []
    var nodes: [Node] = []

    mutating func edge(_ from: Int, to: Int, directed: Bool = false, weight: W) {
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    mutating func edge(_ from: Node, to: Node, directed: Bool = false, weight: W) {
        guard let (from, to) = indices(of: from, to) else { return }
        add(edge: _WeightedEdge(u: from, v: to, directed: directed, weight: weight))
    }

    typealias N = Node
    typealias E = _WeightedEdge<Weight>
}
