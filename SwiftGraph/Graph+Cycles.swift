//
//  Graph+Cycles.swift
//  SwiftGraph
//
//  Created by Jasen Kennington on 10/3/16.
//  Copyright © 2016 Oak Snow Consulting. All rights reserved.
//

import Foundation

extension Graph {
    public func depthFirstSearch(from: Int, to: Int) -> [Int]? {
        var visited: [Bool] = [Bool].init(repeating: false, count: self.vertexCount)
        var pre: [Int?] = [Int?].init(repeating: nil, count: self.vertexCount)
        var post: [Int?] = [Int?].init(repeating: nil, count: self.vertexCount)
        var parent: [Int: Int] = [:]
        
        var clock = 1
    
        func previsit(_ v: Int, clock: inout Int, pre: inout [Int?]) {
            pre[v] = clock
            clock = clock + 1
        }
        
        func postvisit(_ v: Int, clock: inout Int, post: inout [Int?]) {
            post[v] = clock
            clock = clock + 1
        }
        
        func explore(_ v: Int, visited: inout [Bool], parent: inout [Int: Int]) {
            visited[v] = true
            previsit(v, clock: &clock, pre: &pre)
            for neighbor in self.neighborsForIndex(v) {
                guard let index = self.indexOfVertex(neighbor) else {
                    fatalError("Vertex not found.")
                }
                if !visited[index] {
                    parent[index] = v
                    explore(index, visited: &visited, parent: &parent)
                }
            }
            postvisit(v, clock: &clock, post: &post)
        }
        
        self.neighborsForIndex(from).forEach {
            [unowned self] in
            guard let index = self.indexOfVertex($0) else {
                fatalError("Vertex not found.")
            }
            if !visited[index] {
                explore(index, visited: &visited, parent: &parent)
            }
        }
        
        print("Pre: \(pre)")
        print("Post: \(post)")
        print("Visited: \(visited)")
        
        if !visited[to] {
            return nil
        }
        
        var path: [Int] = []
        var current: Int? = to
        while current != nil
        {
            path.append(current!)
            current = parent[current!]
        }
        return path.reversed()
    }
}

enum EdgeType {
    case tree
    case forward
    case back
    case cross
    
    init(preU: Int, preV: Int, postU: Int, postV: Int) {
        if preU < preV && preV < postV && postV < postU {
            self = .forward
        }
        
        if preV < preU && preU < postU && postU < postV {
            self = .back
        }
        
        if preV < postV && postV < preU && preU < postU {
            self = .cross
        }
        
        fatalError("Illegal input. Each index must be unique.")
    }
}
