//
//  Search.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2016 David Kopec
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

public extension Graph {

    /// This is the old dfs as implemented in 2bd8902a782ee301c32679ac1ba2239c2b63d02d
    /// We use it to compare its performance with the new implementation
    public func referneceDfs(from: Int, goalTest: (V) -> Bool) -> [E] {
        // pretty standard dfs that doesn't visit anywhere twice; pathDict tracks route
        var visited: [Bool] = [Bool](repeating: false, count: vertexCount)
        let stack: Stack<Int> = Stack<Int>()
        var pathDict: [Int: E] = [Int: E]()
        stack.push(from)
        while !stack.isEmpty {
            let v: Int = stack.pop()
            if goalTest(vertexAtIndex(v)) {
                // figure out route of edges based on pathDict
                return pathDictToPath(from: from, to: v, pathDict: pathDict) as! [Self.E]
            }
            visited[v] = true
            for e in edgesForIndex(v) {
                if !visited[e.v] {
                    stack.push(e.v)
                    pathDict[e.v] = e
                }
            }
        }
        return [] // no route found
    }
}
