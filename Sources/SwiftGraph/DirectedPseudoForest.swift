//
//  DirectedPseudoForest.swift
//  SwiftGraph
//
//  Copyright (c) 2020 Ferran Pujol Camins
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

// A subclass of `UniqueElementsGraph` where every vertex has at most one outgoing edge.
open class DirectedPseudoForest<V: Equatable & Codable, E: Edge & Equatable>: UniqueElementsGraph<V, E> {

    public override func addEdge(_ e: E, directed: Bool = false) {
        guard self.edgesForIndex(e.u).count == 0 else { return }
        super.addEdge(e)
    }
}
