//
//  Cycle.swift
//  SwiftGraph
//
//  Copyright (c) 2017-2019 David Kopec
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

/// Functions for finding cycles in a `Graph`
// MARK: Extension to `Graph` for detecting cycles
public extension Graph {
    // Based on an algorithm developed by Hongbo Liu and Jiaxin Wang
    // Liu, Hongbo, and Jiaxin Wang. "A new way to enumerate cycles in graph."
    // In Telecommunications, 2006. AICT-ICIW'06. International Conference on Internet and
    // Web Applications and Services/Advanced International Conference on, pp. 57-57. IEEE, 2006.
    
    /// Find all of the cycles in a `Graph`, expressed as vertices.
    ///
    /// - parameter upToLength: Does the caller only want to detect cycles up to a certain length?
    /// - returns: a list of lists of vertices in cycles
    func detectCycles(upToLength maxK: Int = Int.max) -> [[V]] {
        var cycles = [[V]]() // store of all found cycles
        var openPaths: [[V]] = vertices.map{ [$0] } // initial open paths are single vertex lists
        
        while openPaths.count > 0 {
            let openPath = openPaths.removeFirst() // queue pop()
            if openPath.count > maxK { return cycles } // do we want to stop at a certain length k
            if let tail = openPath.last, let head = openPath.first, let neighbors = neighborsForVertex(tail) {
                for neighbor in neighbors {
                    if neighbor == head {
                        cycles.append(openPath + [neighbor]) // found a cycle
                    } else if !openPath.contains(neighbor) && indexOfVertex(neighbor)! > indexOfVertex(head)! {
                        openPaths.append(openPath + [neighbor]) // another open path to explore
                    }
                }
            }
        }
        
        return cycles
    }

    typealias Path = [E]
    typealias PathTuple = (start: Int, path: Path)
    /// Find all of the cycles in a `Graph`, expressed as edges.
    ///
    /// - parameter upToLength: Does the caller only want to detect cycles up to a certain length?
    /// - returns: a list of lists of edges in cycles
    func detectCyclesAsEdges(upToLength maxK: Int = Int.max) -> [[E]] {

        var cycles = [[E]]() // store of all found cycles
        var openPaths: [PathTuple] = (0..<vertices.count).map{ ($0, []) } // initial open paths start at a vertex, and are empty

        while openPaths.count > 0 {
            let openPath = openPaths.removeFirst() // queue pop()
            if openPath.path.count > maxK { return cycles } // do we want to stop at a certain length k
            let tail = openPath.path.last?.v ?? openPath.start
            let head = openPath.start
            let neighborEdges = edgesForIndex(tail)
            for neighborEdge in neighborEdges {
                if neighborEdge.v == head {
                    cycles.append(openPath.path + [neighborEdge]) // found a cycle
                } else if !openPath.path.contains(where: { $0.u == neighborEdge.v || $0.v == neighborEdge.v }) && neighborEdge.v > head {
                    openPaths.append((openPath.start, openPath.path + [neighborEdge])) // another open path to explore
                }
            }
        }

        return cycles
    }
}

///// Data structure used exclusively in `detectCylesAsEdges()`
//fileprivate struct Path {
//    var start: Int
//    var path: [Edge] = []
//
//    init(start: Int) {
//        self.start = start
//    }
//
//    func byAdding(_ edge: Edge) -> Path {
//        var mutable = self
//        mutable.path.append(edge)
//        return mutable
//    }
//
//    var head: Int {
//        return start
//    }
//
//    var tail: Int {
//        return path.last?.v ?? start
//    }
//}
