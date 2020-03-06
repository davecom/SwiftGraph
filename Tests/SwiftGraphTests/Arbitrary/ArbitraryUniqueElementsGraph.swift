//
//  ArbitraryUniqueElementsGraph.swift
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

import SwiftGraph
import SwiftCheck

final class ArbitraryUniqueElementsGraph<V, E>: UniqueElementsGraph<V, E>, Arbitrary where V: Equatable & Codable & Arbitrary, E: Edge & Hashable & Arbitrary {

    static var arbitrary: Gen<ArbitraryUniqueElementsGraph<V, E>> {
        Gen<ArbitraryUniqueElementsGraph>.compose { c in
            let forest = ArbitraryUniqueElementsGraph<V, E>()
            forest.vertices = c.generate()
            forest.edges = forest.vertices.map { _ in c.generate() }
            return forest
        }
        .suchThat { uniqueElementsGraphIsValid($0) }
    }

    static func shrink(_ forest: ArbitraryUniqueElementsGraph) -> [ArbitraryUniqueElementsGraph] {
        [V].shrink(forest.vertices).reversed().filter { $0.count > 0}
            .map { verticesToRemove -> ArbitraryUniqueElementsGraph<V, E> in
                var newForest = forest.copy()
                verticesToRemove.forEach { newForest.removeVertex($0) }
                assert(graphIsValid(newForest))
                return newForest
        }
    }
}
