//
//  WeightedEdge.swift
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

/// This protocol is needed for Dijkstra's algorithm - we need weights in weighted graphs
/// to be able to be added together.
public protocol Summable: Comparable {
    static func + (lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension Float: Summable {}
extension String: Summable {}

/// A weighted edge whose weight conforms to Comparable.
public protocol WeightedEdge: Edge, Comparable {
    associatedtype W: Summable
    var weight: W { get }

    init(u: Int, v: Int, directed: Bool, weight: W)
}

extension WeightedEdge {
    public var weighted: Bool {
        return true
    }

    public var reversed: Self {
        return Self(u: v, v: u, directed: directed, weight: weight)
    }
}

extension WeightedEdge {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.weight < rhs.weight
    }
}

extension WeightedEdge {
    public var description: String {
        return directed ? "\(u) \(weight)> \(v)" : "\(u) <\(weight)> \(v)"
    }
}
