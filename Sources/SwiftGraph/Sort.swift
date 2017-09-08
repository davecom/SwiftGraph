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

/// Functions for sorting a `Graph`
// MARK: Extension to `Graph` for toplogical sorting
public extension Graph {
    // Based on Introduction to Algorithms, 3rd Edition, Cormen et. al., 
    // The MIT Press, 2009, pg 604-614
    // and revised pseudocode of the same from Wikipedia
    // https://en.wikipedia.org/wiki/Topological_sorting#Depth-first_search
    
    /// Topologically sorts a `Graph` O(n)
    ///
    /// - returns: the sorted vertices, or nil if the graph cannot be sorted due to not being a DAG
    public func topologicalSort() -> [V]? {
        var sortedVertices = [V]()
        let tsNodes = vertices.map{ TSNode<V>(vertex: $0, color: .white) }
        var notDAG = false
        
        func visit(_ node: TSNode<V>) {
            guard node.color != .gray else {
                notDAG = true
                return
            }
            if node.color == .white {
                node.color = .gray
                for inode in tsNodes where (neighborsForVertex(node.vertex)?.contains(inode.vertex))! {
                    visit(inode)
                }
                node.color = .black
                sortedVertices.insert(node.vertex, at: 0)
            }
        }
        
        for node in tsNodes where node.color == .white {
            visit(node)
        }
        
        if notDAG {
            return nil
        }
        
        return sortedVertices
    }
    
    
    /// Is the `Graph` a directed-acyclic graph (DAG)? O(n)
    /// Finds the answer based on the result of a topological sort.
    public var isDAG: Bool {
        guard let _ = topologicalSort() else { return false }
        return true
    }
}

// MARK: Utility structures for topological sorting

fileprivate enum TSColor { case black, gray, white }

fileprivate class TSNode<V> {
    fileprivate let vertex: V
    fileprivate var color: TSColor
    
    init(vertex: V, color: TSColor) {
        self.vertex = vertex
        self.color = color
    }
}
