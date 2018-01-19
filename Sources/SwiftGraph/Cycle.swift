//
//  Cycle.swift
//  SwiftGraph
//
//  Copyright (c) 2017 David Kopec
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

// MARK: Cycles

extension Graph {
    // Based on an algorithm developed by Hongbo Liu and Jiaxin Wang
    // Liu, Hongbo, and Jiaxin Wang. "A new way to enumerate cycles in graph."
    // In Telecommunications, 2006. AICT-ICIW'06. International Conference on Internet and
    // Web Applications and Services/Advanced International Conference on, pp. 57-57. IEEE, 2006.

    /// Find all of the cycles in a `Graph`, expressed as nodes.
    ///
    /// - parameter length: Does the caller only want to detect cycles up to a certain length?
    /// - returns: a list of lists of nodes in cycles
    public func cycles(until length: Int = Int.max) -> [[N]] {
        var cycles: [[N]] = .init() // store of all found cycles
        var openPaths: [[N]] = nodes.map { [$0] } // initial open paths are single node lists

        while !openPaths.isEmpty {
            let openPath = openPaths.removeFirst() // queue pop()
            if openPath.count > length { return cycles } // do we want to stop at a certain length k

            if let tail = openPath.last, let head = openPath.first, let neighbors = neighbors(for: tail) {
                for neighbor in neighbors {
                    if neighbor == head {
                        cycles.append(openPath + [neighbor]) // found a cycle
                    } else if !openPath.contains(neighbor) && index(of: neighbor)! > index(of: head)! {
                        openPaths.append(openPath + [neighbor]) // another open path to explore
                    }
                }
            }
        }

        return cycles
    }

    /// Find all of the cycles in a `Graph`, expressed as edges.
    ///
    /// - parameter length: Does the caller only want to detect cycles up to a certain length?
    /// - returns: a list of lists of edges in cycles
    public func cycles(until length: Int = Int.max) -> [[E]] {
        var cycles = [[E]]() // store of all found cycles
        var openPaths: [Path<E>] = (0 ..< nodes.count).map(Path<E>.init(start:)) // initial open paths start at a node, and are empty

        while !openPaths.isEmpty {
            let openPath = openPaths.removeFirst() // queue pop()
            if openPath.path.count > length { return cycles } // do we want to stop at a certain length

            let tail = openPath.tail
            let head = openPath.head
            let neighborEdges = edges(for: tail)
            for neighborEdge in neighborEdges {
                if neighborEdge.target == head {
                    cycles.append(openPath.path + [neighborEdge]) // found a cycle
                } else if !openPath.path.contains(where: { $0.source == neighborEdge.target || $0.target == neighborEdge.target }) && neighborEdge.target > head {
                    openPaths.append(openPath.byAdding(neighborEdge)) // another open path to explore
                }
            }
        }

        return cycles
    }
}

// MARK: Cycles Utilities

private struct Path<E: Edge> {
    var start: Int
    var path: [E] = []
    var head: Int { return start }
    var tail: Int { return path.last?.target ?? start }

    init(start: Int) { self.start = start }

    func byAdding(_ edge: E) -> Path {
        var path = self
        path.path.append(edge)
        return path
    }
}
