//
//  UnweightedEdge.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2016 David Kopec
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

/// A basic unweighted edge.
public protocol UnweightedEdge: Edge {
    init(source: Int, target: Int, directed: Bool)
}

extension UnweightedEdge {
    public var weighted: Bool {
        return false
    }

    public var reversed: Self {
        return Self(source: target, target: source, directed: directed)
    }
}

extension UnweightedEdge {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.source == rhs.source && lhs.target == rhs.target && lhs.directed == rhs.directed
    }
}

extension UnweightedEdge {
    public var description: String {
        return directed ? "\(source) -> \(target)" : "\(source) <-> \(target)"
    }
}
