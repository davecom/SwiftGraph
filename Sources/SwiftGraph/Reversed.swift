//
//  Reversed.swift
//  SwiftGraph
//
//  Created by Matthew Paletta on 2021-02-18.
//  Copyright © 2021 Oak Snow Consulting. All rights reserved.
//

import Foundation

extension Graph {
    /// Returns a graph of the same type with all edges reversed.
    ///
    /// - returns: Graph of the same type with all edges reversed.
    public func reversed() -> Self {
        let g = Self(vertices: self.vertices)
        for e in self.edgeList() {
            g.addEdge(e.reversed(), directed: e.directed)
        }
        return g
    }
}
