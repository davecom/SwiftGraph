//
//  GraphProperties.swift
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
import SwiftGraph
import SwiftCheck

extension Collection where Element: Hashable {
    func allDistinct() -> Bool {
        Set(self).count == count
    }
}

public func graphIsValid<G: Graph>(_ g: G) -> Bool {
    func eachVertexHasAnEdgesArray() -> Bool {
        g.edges.count == g.vertexCount
    }

    func edgeHasValidSourceAndTarget(_ e: G.E, sourceIndex i: Int) -> Bool {
        e.u == i && e.v < g.vertexCount
    }

    func undirectedEdgeHasReversedEdgeInGraph(_ e: G.E) -> Bool {
        if e.directed {
            return g.edges[e.v].contains(e.reversed())
        }
        return true
    }

    return eachVertexHasAnEdgesArray()
        && g.edges.enumerated().allSatisfy { arg in
            let (i, edges) = arg
            return edges.allSatisfy { e in
                edgeHasValidSourceAndTarget(e, sourceIndex: i)
                    && undirectedEdgeHasReversedEdgeInGraph(e)
            }
        }
}

public func uniqueElementsGraphIsValid<V, E>(_ g: UniqueElementsGraph<V, E>) -> Bool
    where V: Hashable & Codable, E: Edge & Hashable {

        graphIsValid(g)
            && g.vertices.allDistinct()
            && g.edges.joined().allDistinct()
}

public func pseudoForestIsValid<V, E>(_ g: DirectedPseudoForest<V, E>) -> Bool
    where V: Hashable & Codable, E: Edge & Hashable {

        uniqueElementsGraphIsValid(g)
            && g.edges.allSatisfy { $0.count <= 1 }
}
