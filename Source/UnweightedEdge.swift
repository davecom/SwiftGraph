//
//  UnweightedEdge.swift
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

/// A basic unweighted edge.
public class UnweightedEdge: Edge, Equatable, CustomStringConvertible {
    public var u: Int
    public var v: Int
    public var weighted: Bool { return false }
    public let directed: Bool
    public var reversed:Edge {
        return UnweightedEdge(u: v, v: u, directed: directed)
    }
    
    public init(u: Int, v: Int, directed: Bool) {
        self.u = u
        self.v = v
        self.directed = directed
    }
    
    //Implement Printable protocol
    public var description: String {
        if directed {
            return "\(u) -> \(v)"
        }
        return "\(u) <-> \(v)"
    }
}

public func ==(lhs: UnweightedEdge, rhs: UnweightedEdge) -> Bool {
    return lhs.u == rhs.u && lhs.v == rhs.v && lhs.directed == rhs.directed
}