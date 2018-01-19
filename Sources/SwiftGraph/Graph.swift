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
public protocol Graph: Collection, Equatable, CustomStringConvertible {
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
    mutating func unedge(_ a: Int, from b: Int, bidirectional: Bool)
    mutating func unedge(_ a: N, from b: N, bidirectional: Bool)

    // edge(:to:) must be implemented in protocols that conform to `Graph`
    // according to the properties of its `E`. See `UnweightedGraph`.

    // MARK: Depth-First Search

    func dfs(from: Int, until at: (N) -> Bool) -> [E]
    func dfs(from: N, until at: (N) -> Bool) -> [E]
    func dfs(from: Int, to: Int) -> [E]
    func dfs(from: N, to: N) -> [E]

    // MARK: Breadth-First Search

    func bfs(from: Int, until at: (N) -> Bool) -> [E]
    func bfs(from: N, until at: (N) -> Bool) -> [E]
    func bfs(from: Int, to: Int) -> [E]
    func bfs(from: N, to: N) -> [E]

    // MARK: Search

    func routes(from: Int, until at: (N) -> Bool) -> [[E]]
    func routes(from: N, until at: (N) -> Bool) -> [[E]]

    func route(from: N, to: N, in path: [Int: E]) -> [E]
    func route(_ from: Int, _ to: Int, in path: [Int: E]) -> [E]

    func nodes(from edges: [E]) -> [N]

    // MARK: Cycle

    func cycles(until length: Int) -> [[N]]
    func cycles(until length: Int) -> [[E]]

    // MARK: Sort

    func toposort() -> [N]?
    func toposort() -> [Int]?
}

// MARK: - Initializers

extension Graph {
    public init(nodes: [N]) {
        self.init()
        _add(nodes: nodes, to: &self)
    }

    public init(nodes: N...) {
        self.init()
        _add(nodes: nodes, to: &self)
    }

    internal func _add(nodes: [N], to graph: inout Self) {
        for node in nodes {
            _add(node, to: &graph)
        }
    }
}

// MARK: - Computed Properties

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
}

// MARK: - Find

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
        func toNode(edge: E) -> N { return nodes[edge.v] }
        return edges[index].map(toNode)
    }

    /// Find all of the neighbors of a given node.
    ///
    /// - parameter node: The node to find the neighbors of.
    /// - returns: An optional array of the neighbor nodes.
    public func neighbors(for node: N) -> [N]? {
        guard let i = index(of: node) else { return nil }
        return neighbors(for: i)
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
        guard let i = index(of: node) else { return nil }
        return edges(for: i)
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

// MARK: - Mutating

extension Graph {
    /// Add a node to the graph.
    ///
    /// - parameter node: The node to be added.
    /// - returns: The index where the node was added.
    public mutating func add(node: N) {
        _add(node, to: &self)
    }

    /// Add an edge to the graph.
    ///
    /// - parameter edge: The edge to add.
    public mutating func add(edge: E) {
        _add(edge, to: &self)
    }

    /// Removes a node at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the node.
    public mutating func remove(at index: Int) {
        _remove(at: index, from: &self)
    }

    /// Removes the first occurence of a node, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter node: The node to be removed.
    public mutating func remove(node: N) {
        _remove(node: node, from: &self)
    }

    /// Removes a specific unweighted edge in both directions (if it's not
    /// directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public mutating func remove(edge: E) {
        _remove(edge: edge, from: &self)
    }

    /// Removes all edges in both directions between nodes at indexes from & to.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unedge(_ a: Int, from b: Int, bidirectional: Bool = true) {
        _unedge(a, from: b, bidirectional: bidirectional, from: &self)
    }

    /// Removes all edges in both directions between two nodes.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unedge(_ a: N, from b: N, bidirectional: Bool = true) {
        _unedge(a, from: b, bidirectional: bidirectional, from: &self)
    }
}

// MARK: - Mutating where Self: AnyObject

extension Graph where Self: AnyObject {
    // To work around the mutating methods in class-based implementations
    // without needlessly constraining the protocol to class, we refine
    // mutating methods with the workaround suggested by Kevin Ballard on
    // the Swift mailing list.
    //
    // Documentation must be maintained in parallel.

    /// Add a node to the graph.
    ///
    /// - parameter node: The node to be added.
    /// - returns: The index where the node was added.
    public func add(node: N) {
        var self_ = self
        _add(node, to: &self_)
    }

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
    public func unedge(_ a: Int, from b: Int, bidirectional: Bool = true) {
        var self_ = self
        _unedge(a, from: b, bidirectional: bidirectional, from: &self_)
    }

    /// Removes all edges in both directions between two nodes.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func unedge(_ a: N, from b: N, bidirectional: Bool = true) {
        var self_ = self
        _unedge(a, from: b, bidirectional: bidirectional, from: &self_)
    }
}

// MARK: - Mutating Internals

internal extension Graph {
    // Internal methods are needed to reuse logic into a class-specific extension
    // where a `mutating` method cannot be used due to immutable `self`.
    //
    // This solution was suggested by Kevin Ballard on the Swift Mailing list
    // (https://is.gd/Hb4f19). See SR-142 (https://bugs.swift.org/browse/SR-142).
    //
    // Avoids needlessly constraining the protocol to class by redefining default
    // implementations within a `where Self: AnyObject` extension. See below.
    //
    // Find the documentation for each method in the next extension.

    internal func _add(_ node: N, to graph: inout Self) {
        graph.nodes.append(node)
        graph.edges.append([E]())
    }

    internal func _add(_ edge: E, to graph: inout Self) {
        graph.edges[edge.u].append(edge)
        if !edge.directed { graph.edges[edge.v].append(edge.reversed) }
    }

    internal func _remove(at index: Int, from graph: inout Self) {
        // remove all edges ending at the node, first doing the ones below it
        // renumber edges that end after the index
        for j in 0 ..< index {
            var trash: [Int] = .init()
            for l in 0 ..< edges[j].count {
                if edges[j][l].v == index {
                    trash.append(l)
                    continue
                }
                if edges[j][l].v > index {
                    graph.edges[j][l].v -= 1
                }
            }
            for f in trash.reversed() {
                graph.edges[j].remove(at: f)
            }
        }

        // remove all edges after the node index wise
        // renumber all edges after the node index wise
        for j in (index + 1) ..< edges.count {
            var trash: [Int] = .init()
            for l in 0 ..< edges[j].count {
                if edges[j][l].v == index {
                    trash.append(l)
                    continue
                }
                graph.edges[j][l].u -= 1
                if edges[j][l].v > index {
                    graph.edges[j][l].v -= 1
                }
            }
            for f in trash.reversed() {
                graph.edges[j].remove(at: f)
            }
        }
        // remove the actual node and its edges
        graph.edges.remove(at: index)
        graph.nodes.remove(at: index)
    }

    internal func _remove(node: N, from graph: inout Self) {
        guard let i = index(of: node) else { return }
        graph.remove(at: i)
    }

    internal func _remove(edge: E, from graph: inout Self) {
        guard let i = (edges[edge.u]).index(of: edge) else { return }
        graph.edges[edge.u].remove(at: i)

        guard !edge.directed, let j = (edges[edge.v]).index(of: edge.reversed) else { return }
        graph.edges[edge.v].remove(at: j)
    }

    internal func _unedge(_ a: Int, from b: Int, bidirectional: Bool = true, from graph: inout Self) {
        for (i, edge) in edges[a].enumerated().reversed() where edge.v == b {
            graph.edges[a].remove(at: i)
        }

        guard bidirectional else { return }

        for (i, edge) in edges[b].enumerated().reversed() where edge.v == a {
            graph.edges[b].remove(at: i)
        }
    }

    internal func _unedge(_ a: N, from b: N, bidirectional: Bool = true, from graph: inout Self) {
        guard let (u, v) = indices(of: a, b) else { return }
        return graph.unedge(u, from: v, bidirectional: bidirectional)
    }
}

// MARK: - CustomStringConvertible

extension Graph {
    public var description: String {
        return nodes.indices.map { "\(nodes[$0]) -> \(neighbors(for: $0))\n" }.joined()
        }
    }

// MARK: - Collection

extension Graph {
    public typealias Index = Int
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return nodeCount }

    public func index(after i: Index) -> Index { return i + 1 }
    public subscript(i: Int) -> N { return node(at: i) }
}

// MARK: - Equatable

extension Graph {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.nodes == rhs.nodes && lhs.edges.elementsEqual(rhs.edges, by: ==)
    }
}
