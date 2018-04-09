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

    func neighbors(_ index: Int) -> [N]
    func neighbors(of node: N) -> [N]?
    func edges(_ index: Int) -> [E]
    func edges(of node: N) -> [E]?

    func contains(_ node: N) -> Bool
    func contains(_ edge: E) -> Bool
    func links(_ a: Int, _ b: Int) -> Bool
    func links(_ a: N, to b: N) -> Bool

    // MARK: Mutate

    mutating func add(_ node: N)
    mutating func add(_ edge: E)
    mutating func remove(_ node: N)
    mutating func remove(_ edge: E)
    mutating func remove(at index: Int)
    mutating func unlink(_ source: Int, _ target: Int, bidirectional: Bool)
    mutating func unlink(_ source: N, from target: N, bidirectional: Bool)

    // link(:to:) must be implemented in protocols that conform to `Graph`
    // according to the properties of its `E`. See `UnweightedGraph`.

    // MARK: Depth-First Search

    func dfs(_ source: Int, until at: (N) -> Bool) -> [E]
    func dfs(from source: N, until at: (N) -> Bool) -> [E]
    func dfs(_ source: Int, _ target: Int) -> [E]
    func dfs(from source: N, to target: N) -> [E]

    // MARK: Breadth-First Search

    func bfs(_ source: Int, until at: (N) -> Bool) -> [E]
    func bfs(from source: N, until at: (N) -> Bool) -> [E]
    func bfs(_ source: Int, _ target: Int) -> [E]
    func bfs(from source: N, to target: N) -> [E]

    // MARK: Search

    func routes(_ source: Int, until at: (N) -> Bool) -> [[E]]
    func routes(from: N, until at: (N) -> Bool) -> [[E]]

    func route(_ source: Int, _ target: Int, in path: [Int: E]) -> [E]
    func route(from source: N, to target: N, in path: [Int: E]) -> [E]

    func nodes(from edges: [E]) -> [N]

    // MARK: Cycle

    func cycles(until length: Int) -> [[N]]
    func cycles(until length: Int) -> [[E]]

    // MARK: Sort

    func toposort() -> [Int]?
}

// MARK: - Initializers

extension Graph {
    public init(nodes: [N]) {
        self.init()
        _add(nodes: nodes)
    }

    public init(nodes: N...) {
        self.init()
        _add(nodes: nodes)
    }

    internal mutating func _add(nodes: [N]) {
        for node in nodes { add(node) }
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
    public func neighbors(_ index: Int) -> [N] {
        func toNode(edge: E) -> N { return nodes[edge.target] }
        return edges[index].map(toNode)
    }

    /// Find all of the neighbors of a given node.
    ///
    /// - parameter node: The node to find the neighbors of.
    /// - returns: An optional array of the neighbor nodes.
    public func neighbors(of node: N) -> [N]? {
        guard let i = index(of: node) else { return nil }
        return neighbors(i)
    }

    /// Find all of the edges of a node at a given index.
    ///
    /// - Note: Prefer the subscript.
    /// - parameter index: The index for the node to find the children of.
    public func edges(_ index: Int) -> [E] {
        return edges[index]
    }

    /// Find all of the edges of a given node.
    ///
    /// - parameter node: The node to find the edges of.
    public func edges(of node: N) -> [E]? {
        guard let i = index(of: node) else { return nil }
        return edges[i]
    }

    /// Find the first occurence of a node.
    ///
    /// - parameter node: The node you are looking for.
    public func contains(_ node: N) -> Bool {
        if index(of: node) == nil { return false }
        return true
    }

    /// Find the first occurence of an edge.
    ///
    /// - parameter edge: The edge you are looking for.
    public func contains(_ edge: E) -> Bool {
        return links(edge.source, edge.target)
    }

    /// Is there an edge from one node to another?
    ///
    /// - parameter from: The index of the starting edge.
    /// - parameter to: The index of the ending edge.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func links(_ a: Int, _ b: Int) -> Bool {
        return edges[a].map { $0.target }.contains(b)
    }

    /// Is there an edge from one node to another? Note this will look at the first
    /// occurence of each node. Also returns false if either of the supplied nodes
    /// cannot be found in the graph.
    ///
    /// - parameter from: The first node.
    /// - parameter to: The second node.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func links(_ a: N, to b: N) -> Bool {
        guard let (a, b) = indices(of: a, b) else { return false }
        return links(a, b)
    }
}

// MARK: - Mutating

extension Graph {
    /// Add a node to the graph.
    ///
    /// - parameter node: The node to be added.
    /// - returns: The index where the node was added.
    public mutating func add(_ node: N) {
        nodes.append(node)
        edges.append([E]())
    }

    /// Add an edge to the graph.
    ///
    /// - parameter edge: The edge to add.
    public mutating func add(_ edge: E) {
        edges[edge.source].append(edge)
        if !edge.directed { edges[edge.target].append(edge.reversed) }
    }

    /// Removes the first occurence of a node, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter node: The node to be removed.
    public mutating func remove(_ node: N) {
        guard let i = index(of: node) else { return }
        remove(at: i)
    }

    /// Removes a specific unweighted edge in both directions (if it's not
    /// directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public mutating func remove(_ edge: E) {
        guard let i = (edges[edge.source]).index(of: edge) else { return }
        edges[edge.source].remove(at: i)

        guard !edge.directed, let j = (edges[edge.target]).index(of: edge.reversed) else { return }
        edges[edge.target].remove(at: j)
    }

    /// Removes a node at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the node.
    public mutating func remove(at index: Int) {
        // remove all edges ending at the node, first doing the ones below it
        // renumber edges that end after the index
        for j in 0 ..< index {
            var trash: [Int] = .init()
            for l in 0 ..< edges[j].count {
                if edges[j][l].target == index {
                    trash.append(l)
                    continue
                }
                if edges[j][l].target > index {
                    edges[j][l].target -= 1
                }
            }
            for f in trash.reversed() {
                edges[j].remove(at: f)
            }
        }

        // remove all edges after the node index wise
        // renumber all edges after the node index wise
        for j in (index + 1) ..< edges.count {
            var trash: [Int] = .init()
            for l in 0 ..< edges[j].count {
                if edges[j][l].target == index {
                    trash.append(l)
                    continue
                }
                edges[j][l].source -= 1
                if edges[j][l].target > index {
                    edges[j][l].target -= 1
                }
            }
            for f in trash.reversed() {
                edges[j].remove(at: f)
            }
        }
        // remove the actual node and its edges
        edges.remove(at: index)
        nodes.remove(at: index)
    }

    /// Removes all edges in both directions between nodes at indexes from & to.
    ///
    /// - parameter from: The starting node's index.
    /// - parameter to: The ending node's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unlink(_ source: Int, _ target: Int, bidirectional: Bool = true) {
        for (i, edge) in edges[source].enumerated().reversed() where edge.target == target {
            edges[source].remove(at: i)
        }

        guard bidirectional else { return }

        for (i, edge) in edges[target].enumerated().reversed() where edge.target == source {
            edges[target].remove(at: i)
        }
    }

    /// Removes all edges in both directions between two nodes.
    ///
    /// - parameter from: The starting node.
    /// - parameter to: The ending node.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unlink(_ source: N, from target: N, bidirectional: Bool = true) {
        guard let (source, target) = indices(of: source, target) else { return }
        return unlink(source, target, bidirectional: bidirectional)
    }

    // Implementation Note
    //
    // A `mutating` method cannot be used within a class due to immutable `self`.
    // Should a class that adopts this protocol have the need to reuse `mutating`
    // logic, internal `inout` implementations of these or the desired `mutating`
    // methods need to be used.
    //
    // We were previously adopting the technique to work around an issue with
    // a generic protocol initializer, but there should be no need to.
    //
    // Implement the `internal` `inout` method by taking the logic out of the `mutating`
    // one, then call the internal one in both the `mutating` method and in the
    // class-specific `nonmutating` method, which must be declared in an extension
    // `where Self: AnyObject`.
    //
    // This solution avoids needlessly constraining the protocol to class. It was
    // suggested by Kevin Ballard on the Swift Mailing list (https://is.gd/Hb4f19).
    // See SR-142 (https://bugs.swift.org/browse/SR-142).
}

// MARK: - CustomStringConvertible

extension Graph {
    public var description: String {
        return nodes.indices.map { "\(nodes[$0]) -> \(neighbors($0))\n" }.joined()
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
