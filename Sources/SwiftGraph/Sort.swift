//
//  Sort.swift
//  SwiftGraph
//
//  Copyright (c) 2016 David Kopec
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

// MARK: Topological Sorting

extension Graph {
    // Based on
    //
    // “Introduction to Algorithms, 3rd Edition, Cormen et. al., The MIT Press, 2009, pg 604-614”
    // https://en.wikipedia.org/wiki/Topological_sorting#Depth-first_search

    /// Topologically sort the graph in `O(n)` time.
    ///
    /// Use `toposort()?.map(node(at:))` or `toposort()?.lazy.map(node(at:))` should you
    /// need all the respective nodes.
    ///
    /// - returns: The _sorted indices_ of the nodes, **or** `nil` if the graph cannot be
    /// sorted because it is a DAG, **or** an `[]` if there are no nodes or edges.
    public func toposort() -> [Int]? {
        guard !edges.joined().isEmpty else { return [] }

        var sorted: [Int] = .init()
        var marks = nodes.map(Topomark.initialize)
        var isDAG = true

        func visit(_ i: Int, with mark: Topomark) {
            func ok() -> Bool {
                if mark ~= .none { return true }
                if mark ~= .temporary { isDAG = false }
                return false
            }

            func deepvisit() {
                for (j, other) in nodes.enumerated() where isDAG && neighbors(i).contains(other) {
                    visit(j, with: marks[j])
                }
            }

            guard ok() else { return }
            marks[i] = .temporary
            deepvisit()
            marks[i] = .permanent
            sorted.insert(i, at: 0)
        }

        for i in nodes.indices where isDAG && marks[i] == .none {
            visit(i, with: marks[i])
        }

        guard isDAG else { return nil }
        return sorted
    }

    /// A Boolean value indicating whether the graph is a _directed acyclic graph (DAG)_.
    /// `O(n)` time because it does a topological sort.
    ///
    /// Given that a directed graph is acyclic if and only if it has a topological ordering,
    /// in case you've already done a topological sort: if the result is `nil` or `[]` then
    /// the graph _is not_ a _DAG_.
    public var isDAG: Bool {
        guard let sorted: [Int] = toposort(), !sorted.isEmpty else { return false }
        return true
    }
}

// MARK: Topological Sorting Utilities

private enum Topomark {
    case permanent
    case temporary
    case none

    static func initialize(_: Any) -> Topomark {
        return .none
    }
}
