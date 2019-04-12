//
//  UnweightedEdge.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2019 David Kopec
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
public struct UnweightedEdge: Edge, CustomStringConvertible, Equatable {
    public var u: Int
    public var v: Int
    public var directed: Bool
    
    public init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }

    public func reversed() -> UnweightedEdge {
        return UnweightedEdge(u: v, v: u, directed: directed)
    }

    // Implement Printable protocol
    public var description: String {
        return "\(u) -> \(v)"
    }

    // MARK: Operator Overloads
    static public func ==(lhs: UnweightedEdge, rhs: UnweightedEdge) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v
    }
}
