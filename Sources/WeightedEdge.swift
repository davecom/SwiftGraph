//
//  WeightedEdge.swift
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

/// This protocol is needed for Dijkstra's algorithm - we need weights in weighted graphs
/// to be able to be added together
public protocol Summable {
    static func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension Float: Summable {}
extension String: Summable {}

/// A weighted edge, who's weight subscribes to Comparable.
open class WeightedEdge<W: Comparable & Summable>: UnweightedEdge {
    public override var weighted: Bool { return true }
    public let weight: W
    public override var reversed:Edge {
        return WeightedEdge(u: v, v: u, directed: directed, weight: weight)
    }
    
    public init(u: Int, v: Int, directed: Bool, weight: W) {
        self.weight = weight
        super.init(u: u, v: v, directed: directed)
    }
    
    //Implement Printable protocol
    public override var description: String {
        if directed {
            return "\(u) \(weight)> \(v)"
        }
        return "\(u) <\(weight)> \(v)"
    }
    
    //MARK: Operator Overloads
    static public func ==<W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
    }
}
