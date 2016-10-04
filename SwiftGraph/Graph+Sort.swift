//
//  Graph+Sort.swift
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
    /// Performs a topological sort of the graph, if possible
    ///
    /// - returns: A valid sorting of indices or nil, if no sort is possible
    public func topologicallySortedIndices() -> [Int]? {
        if !self.isAcyclic() {
            return nil
        }
        
        var visited: [Bool] = [Bool].init(repeating: false, count: self.vertexCount)
        var pre: [Int] = [Int].init(repeating: 0, count: self.vertexCount)
        var post: [Int] = [Int].init(repeating: 0, count: self.vertexCount)
        
        var clock = 1
        
        func previsit(_ v: Int, clock: inout Int, pre: inout [Int]) {
            pre[v] = clock
            clock = clock + 1
        }
        
        func postvisit(_ v: Int, clock: inout Int, post: inout [Int]) {
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
        
        let result = zip(self.indices, post)
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        return result
    }
    
    /// Performs a topological sort of the graph, if possible
    ///
    /// - returns: A valid sorting of vertices or nil, if no sort is possible
    public func topologicallySortedVertices() -> [V]? {
        return topologicallySortedIndices()?
            .map {
                self.vertexAtIndex($0)
        }
    }
}
