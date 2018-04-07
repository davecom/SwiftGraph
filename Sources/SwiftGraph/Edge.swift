//
//  Edge.swift
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

/// A protocol that all edges in a graph must conform to.
public protocol Edge: CustomStringConvertible {
    /// The origin vertex of the edge
    var u: Int {get set}  //made modifiable for changing when removing vertices
    /// The destination vertex of the edge
    var v: Int {get set}  //made modifiable for changing when removing vertices
    var weighted: Bool {get}
    var directed: Bool {get}
    var reversed: Edge {get}

    func isEqualTo(_ other: Edge) -> Bool
    func asEquatable() -> AnyEquatableEdge
}

extension Edge {
    public func asEquatable() -> AnyEquatableEdge {
        return AnyEquatableEdge(self)
    }
}

/// Type erasure over Edge subclasses that implements Equatable
public struct AnyEquatableEdge: Edge, Equatable {
    public init(_ edge: Edge) {
        self.edge = edge
    }
    public init(_ anyEdge: AnyEquatableEdge) {
        self.edge = anyEdge.edge
    }

    public var u: Int {
        get {
            return edge.u
        }
        set(newU) {
            edge.u = newU
        }
    }
    public var v: Int {
        get {
            return edge.v
        }
        set(newV) {
            edge.v = newV
        }
    }
    public var weighted: Bool { get { return edge.weighted } }
    public var directed: Bool { get { return edge.directed } }
    public var reversed: Edge { get { return edge.reversed } }

    public func isEqualTo(_ other: Edge) -> Bool {
        return edge.isEqualTo(other)
    }

    public func asEquatable() -> AnyEquatableEdge {
        return self
    }

    public static func ==(lhs: AnyEquatableEdge, rhs: AnyEquatableEdge) -> Bool {
        return lhs.edge.isEqualTo(rhs.edge)
    }

    //Implement Printable protocol
    public var description: String {
        return edge.description
    }

    private var edge: Edge
}
