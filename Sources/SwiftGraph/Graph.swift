//
//  Graph.swift
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

/// A graph protocol.
public protocol Graph: Collection, CustomStringConvertible {
    associatedtype N: Hashable
    associatedtype E: Edge

    // MARK: Properties

    var nodes: [N] { get set }
    var edges: [[E]] { get set }

    var nodeCount: Int { get }
    var edgeCount: Int { get }

    var isDAG: Bool { get }
    var immutableNodes: [N] { get }

    // MARK: Initializers

    init()
    init(nodes: [N])

    // MARK: Find

    func node(at index: Int) -> N
    func index(of node: N) -> Int?
    func indices(of a: N, _ b: N) -> (Int, Int)?

    func neighbors(for index: Int) -> [N]
    func neighbors(for node: N) -> [N]?
    func edges(for index: Int) -> [E]
    func edges(for node: N) -> [E]?

    func contains(node: N) -> Bool
    func contains(edge: E) -> Bool
    func edged(from: Int, to: Int) -> Bool
    func edged(from: N, to: N) -> Bool

    // MARK: Mutate

    mutating func add(node: N)
    mutating func add(edge: E)
    mutating func remove(at index: Int)
    mutating func remove(node: N)
    mutating func remove(edge: E)
    mutating func unedge(_ from: Int, to: Int, bidirectional: Bool)
    mutating func unedge(_ from: N, to: N, bidirectional: Bool)

    // edge(:to:) must be implemented in protocols that conform to `Graph`
    // according to the properties of its `E`. See `UnweightedGraph`.

    // MARK: Depth-First Search

    func dfs(from: Int, until test: (N) -> Bool) -> [E]
    func dfs(from: N, until test: (N) -> Bool) -> [E]
    func dfs(from: Int, to: Int) -> [E]
    func dfs(from: N, to: N) -> [E]

    // MARK: Breadth-First Search

    func bfs(from: Int, until test: (N) -> Bool) -> [E]
    func bfs(from: N, until test: (N) -> Bool) -> [E]
    func bfs(from: Int, to: Int) -> [E]
    func bfs(from: N, to: N) -> [E]

    // MARK: Search

    func routes(from: Int, until test: (N) -> Bool) -> [[E]]
    func routes(from: N, until test: (N) -> Bool) -> [[E]]

    func route(from: N, to: N, in path: [Int: E]) -> [E]
    func route(_ from: Int, _ to: Int, in path: [Int: E]) -> [E]

    func nodes(from edges: [E]) -> [N]

    // MARK: Cycle

    func cycles(until length: Int) -> [[N]]
    func cycles(until length: Int) -> [[E]]

    // MARK: Sort

    func topologicalSort() -> [N]?
}

extension Graph {
    /// How many nodes are in the graph?
    public var nodeCount: Int {
        return nodes.count
    }

    /// How many edges are in the graph?
    public var edgeCount: Int {
        return edges.joined().count
    }

    /// An immutable array containing all of the nodes in the graph.
    public var immutableNodes: [N] {
        return nodes
    }

    public init(nodes: [N]) {
        self.init()
        for node in nodes {
            add(node: node)
        }
    }
}

extension Graph {
    /// Get a node by its index.
    ///
    /// - parameter index: The index of the node.
    /// - returns: The node at i.
    public func node(at index: Int) -> N {
        return nodes[index]
    }

    /// Find the first occurence of a node if it exists.
    ///
    /// - parameter node: The node you are looking for.
    /// - returns: The index of the node. Return nil if it can't find it.
    public func index(of node: N) -> Int? {
        return nodes.index(of: node)
    }

    /// Finds the first the first occurence of two nodes. O(n).
    ///
    /// - parameter a: A node.
    /// - parameter b: A node.
    /// - returns: A tuple with the indices of the nodes, or nil.
    public func indices(of a: N, _ b: N) -> (Int, Int)? {
        guard let a = index(of: a), let b = index(of: b) else { return nil }
        return (a, b)
    }

    /// Find all of the neighbors of a node at a given index.
    ///
    /// - parameter index: The index for the node to find the neighbors of.
    /// - returns: An array of the neighbor nodes.
    public func neighbors(for index: Int) -> [N] {
        return edges[index].map { self.nodes[$0.v] }
    }

    /// Find all of the neighbors of a given node.
    ///
    /// - parameter node: The node to find the neighbors of.
    /// - returns: An optional array of the neighbor nodes.
    public func neighbors(for node: N) -> [N]? {
        if let i = index(of: node) {
            return neighbors(for: i)
        }
        return nil
    }

    /// Find all of the edges of a node at a given index.
    ///
    /// - parameter index: The index for the node to find the children of.
    public func edges(for index: Int) -> [E] {
        return edges[index]
    }

    /// Find all of the edges of a given node.
    ///
    /// - parameter node: The node to find the edges of.
    public func edges(for node: N) -> [E]? {
        if let i = index(of: node) {
            return edges(for: i)
        }
        return nil
    }

    /// Find the first occurence of a node.
    ///
    /// - parameter node: The node you are looking for.
    public func contains(node: N) -> Bool {
        if index(of: node) == nil { return false }
        return true
    }

    /// Find the first occurence of an edge.
    ///
    /// - parameter edge: The edge you are looking for.
    public func contains(edge: E) -> Bool {
        return edged(from: edge.u, to: edge.v)
    }

    /// Is there an edge from one node to another?
    ///
    /// - parameter from: The index of the starting edge.
    /// - parameter to: The index of the ending edge.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edged(from: Int, to: Int) -> Bool {
        return edges[from].map { $0.v }.contains(to)
    }

    /// Is there an edge from one node to another? Note this will look at the first
    /// occurence of each node. Also returns false if either of the supplied nodes
    /// cannot be found in the graph.
    ///
    /// - parameter from: The first node.
    /// - parameter to: The second node.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edged(from: N, to: N) -> Bool {
        guard let (u, v) = indices(of: from, to) else { return false }
        return edged(from: u, to: v)
    }
}

extension Graph {
    /// Add a node to the graph.
    ///
    /// - parameter v: The node to be added.
    /// - returns: The index where the node was added.
    public mutating func add(node: N) {
        _add(node, to: &self)
    }

    internal func _add(_ node: N, to graph: inout Self) {
        graph.nodes.append(node)
        graph.edges.append([E]())
    }

    /// Add an edge to the graph.
    ///
    /// - parameter edge: The edge to add.
    public mutating func add(edge: E) {
        _add(edge, to: &self)
    }

    /// Needed to reuse the `add` logic into a class-based extension
    /// where a `mutating func` cannot be used due to immutable `self`.
    ///
    /// The same approach should be used in case mutating methods need to
    /// be used internally. This solution was suggested [by Kevin Ballard
    /// on the Swift Mailing List](https://is.gd/Hb4f19). There are others
    /// in the thread, but this seems to be the best.
    ///
    /// See [SR-142](https://bugs.swift.org/browse/SR-142).
    internal func _add(_ edge: E, to graph: inout Self) {
        graph.edges[edge.u].append(edge)
        if !edge.directed {
            graph.edges[edge.v].append(edge.reversed)
        }
    }

    /// Removes a node at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the node.
    public mutating func remove(at index: Int) {
        _remove(at: index, from: &self)
    }

    internal func _remove(at index: Int, from graph: inout Self) {
        // remove all edges ending at the node, first doing the ones below it
        // renumber edges that end after the index
        for j in 0 ..< index {
            var toRemove: [Int] = [Int]()
            for l in 0 ..< edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                if edges[j][l].v > index {
                    graph.edges[j][l].v -= 1
                }
            }
            for f in toRemove.reversed() {
                graph.edges[j].remove(at: f)
            }
        }

        // remove all edges after the node index wise
        // renumber all edges after the node index wise
        for j in (index + 1) ..< edges.count {
            var toRemove: [Int] = [Int]()
            for l in 0 ..< edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                graph.edges[j][l].u -= 1
                if edges[j][l].v > index {
                    graph.edges[j][l].v -= 1
                }
            }
            for f in toRemove.reversed() {
                graph.edges[j].remove(at: f)
            }
        }
        // remove the actual node and its edges
        graph.edges.remove(at: index)
        graph.nodes.remove(at: index)
    }

    /// Removes the first occurence of a node, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter node: The node to be removed.
    public mutating func remove(node: N) {
        _remove(node: node, from: &self)
    }

    internal func _remove(node: N, from graph: inout Self) {
        if let i = index(of: node) {
            return graph.remove(at: i)
        }
    }

    /// Removes a specific unweighted edge in both directions (if it's not
    /// directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public mutating func remove(edge: E) {
        _remove(edge: edge, from: &self)
    }

    internal func _remove(edge: E, from graph: inout Self) {
        if let i = (edges[edge.u]).index(of: edge) {
            graph.edges[edge.u].remove(at: i)
            if !edge.directed {
                if let i = (edges[edge.v]).index(of: edge.reversed) {
                    graph.edges[edge.v].remove(at: i)
                }
            }
        }
    }

    /// Removes all edges in both directions between nodes at indexes from & to.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unedge(_ from: Int, to: Int, bidirectional: Bool = true) {
        _unedge(from, to: to, bidirectional: bidirectional, from: &self)
    }

    internal func _unedge(_ from: Int, to: Int, bidirectional: Bool = true, from graph: inout Self) {
        for (i, edge) in edges[from].enumerated().reversed() where edge.v == to {
            graph.edges[from].remove(at: i)
        }

        if bidirectional {
            for (i, edge) in edges[to].enumerated().reversed() where edge.v == from {
                graph.edges[to].remove(at: i)
            }
        }
    }

    /// Removes all edges in both directions between two nodes.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unedge(_ from: N, to: N, bidirectional: Bool = true) {
        _unedge(from, to: to, bidirectional: bidirectional, from: &self)
    }

    internal func _unedge(_ from: N, to: N, bidirectional: Bool = true, from graph: inout Self) {
        guard let (u, v) = indices(of: from, to) else { return }
        return graph.unedge(u, to: v, bidirectional: bidirectional)
    }
}

extension Graph where Self: AnyObject {
    // To work around the mutating methods in class-based implementations
    // without needlessly constraining the protocol to class, we refine
    // mutating methods with the workaround suggested by Kevin Ballard on
    // the Swift mailing list. See `_add(:to:)`.
    //
    // Documentation must be maintained in parallel.

    /// Add an edge to the graph.
    ///
    /// - parameter edge: The edge to add.
    public func add(edge: E) {
        var self_ = self
        _add(edge, to: &self_)
    }

    /// Removes a node at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the node.
    public func remove(at index: Int) {
        var self_ = self
        _remove(at: index, from: &self_)
    }

    /// Removes the first occurence of a node, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter node: The node to be removed.
    public func remove(node: N) {
        var self_ = self
        _remove(node: node, from: &self_)
    }

    /// Removes a specific unweighted edge in both directions (if it's not
    /// directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public func remove(edge: E) {
        var self_ = self
        _remove(edge: edge, from: &self_)
    }

    /// Removes all edges in both directions between nodes at indexes from & to.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func unedge(_ from: Int, to: Int, bidirectional: Bool = true) {
        var self_ = self
        _unedge(from, to: to, bidirectional: bidirectional, from: &self_)
    }

    /// Removes all edges in both directions between two nodes.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func unedge(_ from: N, to: N, bidirectional: Bool = true) {
        var self_ = self
        _unedge(from, to: to, bidirectional: bidirectional, from: &self_)
    }
}

extension Graph { // Printable
    public var description: String {
        var d: String = ""
        for i in 0 ..< nodes.count {
            d += "\(nodes[i]) -> \(neighbors(for: i))\n"
        }
        return d
    }
}

extension Graph { // Collection
    public typealias Index = Int
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return nodeCount }

    public func index(after i: Index) -> Index { return i + 1 }
    public subscript(i: Int) -> N { return node(at: i) }
}
