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


/// A weighted edge, who's weight subscribes to Comparable.
public struct WeightedEdge<W: Comparable & Numeric & Codable>: SearchableByNodes, CustomStringConvertible, Codable, Comparable {
    public var u: Int
    public var v: Int
    public var weight: W
    
    public init(u: Int, v: Int, weight: W) {
        self.u = u
        self.v = v
        self.weight = weight
    }

    // Implement Printable protocol
    public var description: String {
        return "\(u) \(weight)> \(v)"
    }
    
    // MARK: Operator Overloads
    static public func == <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.weight == rhs.weight
    }
    
    static public func < <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.weight < rhs.weight
    }
}
