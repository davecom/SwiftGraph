//
//  WeightedEdge.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2015 David Kopec
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

/// This protocol is needed for Dijkstra's algorithm - we need weights in weighted graphs
/// to be able to be added together
public protocol Summable {
    func +(lhs: Self, rhs: Self) -> Self
}

extension Int: Summable {}
extension Double: Summable {}
extension Float: Summable {}
extension String: Summable {}

/// A weighted edge, who's weight subscribes to Comparable.
public class WeightedEdge<W: protocol<Comparable, Summable>>: UnweightedEdge {
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
}

public func ==<W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed && lhs.weight == rhs.weight
}
