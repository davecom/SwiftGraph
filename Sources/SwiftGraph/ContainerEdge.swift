//
//  ContainerEdge.swift
//  SwiftGraph
//
//  Copyright (c) 2019 Ferran Pujol Camins
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


/// An edge that holds an equatable type. Two edges are equal if and only if they have same nodes and value.
public struct ContainerEdge<T: Equatable>: Edge, CustomStringConvertible {
    typealias U = T
    public var u: Int
    public var v: Int
    public var value: T

    public init(u: Int, v: Int, value: T) {
        self.u = u
        self.v = v
        self.value = value
    }

    // MARK: Operator Overloads
    static public func ==(lhs: ContainerEdge, rhs: ContainerEdge) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.value == rhs.value
    }
}

extension ContainerEdge {
    // Implement Printable protocol
    public var description: String {
        return "\(u) -> \(v)"
    }
}

extension ContainerEdge where T: CustomStringConvertible {
    // Implement Printable protocol
    public var description: String {
        return "\(u) -[\(value)]-> \(v)"
    }
}
