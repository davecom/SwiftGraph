//
//  Graph+Cycles.swift
//  SwiftGraph
//
//  Copyright (c) 2016 Jasen Kennington
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
    /// Check if the graph is acyclic
    ///
    /// - returns: Whether the graph is acyclic or not
    public func isAcyclic() -> Bool {
        var visited: [Bool] = [Bool].init(repeating: false, count: self.vertexCount)
        var pre: [Int?] = [Int?].init(repeating: nil, count: self.vertexCount)
        var post: [Int?] = [Int?].init(repeating: nil, count: self.vertexCount)
        var clock = 1
        
        func previsit(_ v: Int, clock: inout Int, pre: inout [Int?]) {
            pre[v] = clock
            clock = clock + 1
        }
        
        func postvisit(_ v: Int, clock: inout Int, post: inout [Int?]) {
            post[v] = clock
            clock = clock + 1
        }
        
        func explore(_ v: Int, visited: inout [Bool]) {
            visited[v] = true
            previsit(v, clock: &clock, pre: &pre)
            for neighbor in self.neighborsForIndex(v) {
                guard let index = self.indexOfVertex(neighbor) else {
                    fatalError("Vertex not found.")
                }
                if !visited[index] {
                    explore(index, visited: &visited)
                }
            }
            postvisit(v, clock: &clock, post: &post)
        }
        
        self.vertices.forEach {
            [unowned self] in
            guard let index = self.indexOfVertex($0) else {
                fatalError("Vertex not found.")
            }
            if !visited[index] {
                explore(index, visited: &visited)
            }
        }
        
        let backEdges: [EdgeType] = self.edges
            .flatMap({ $0 })
            .flatMap {
                edge in
                let u = edge.u
                let v = edge.v
                
                guard let preU = pre[u],
                    let preV = pre[v],
                    let postU = post[u],
                    let postV = post[v] else {
                        fatalError("Edge was somehow not visited.")
                }

                return EdgeType.init(preU: preU, preV: preV, postU: postU, postV: postV)
            }
            .filter {
                switch $0 {
                case .back: return true
                default: return false
                }
        }
        
        return !(backEdges.count > 0)
    }
}

internal enum EdgeType {
    case treeForward
    case back
    case cross
    
    init(preU: Int, preV: Int, postU: Int, postV: Int) {
        if preU < preV && preV < postV && postV < postU {
            self = .treeForward
            return
        }
        
        if preV < preU && preU < postU && postU < postV {
            self = .back
            return
        }
        
        if preV < postV && postV < preU && preU < postU {
            self = .cross
            return
        }
        
        if preU == preV && postU == postV {
            // self loop
            self = .back
            return
        }
        
        fatalError("Illegal input. Each index must be unique.")
    }
}
