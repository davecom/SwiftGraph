//
//  Reversed.swift
//  SwiftGraph
//
//  Created by Matthew Paletta on 2021-02-18.
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

import Foundation

extension Graph {
    /// Returns a graph of the same type with all edges reversed.
    ///
    /// - returns: Graph of the same type with all edges reversed.
    public func reversed() -> Self {
        let g = Self(vertices: self.vertices)
        for e in self.edgeList() {
            g.addEdge(e.reversed(), directed: e.directed)
        }
        return g
    }
}
