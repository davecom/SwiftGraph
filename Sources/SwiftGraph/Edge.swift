//
//  Edge.swift
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

/// A protocol that all edges in a graph must conform to.
public protocol Edge: CustomStringConvertible {
    /// The origin vertex of the edge
    var u: Int {get set}  //made modifiable for changing when removing vertices
    /// The destination vertex of the edge
    var v: Int {get set}  //made modifiable for changing when removing vertices
    var directed: Bool { get set }
    // Returns an edge with the origin and destination reversed
    func reversed() -> Self
}
