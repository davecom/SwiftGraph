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
    associatedtype V: Hashable
    associatedtype E: Edge

    // MARK: Properties

    var vertices: [V] { get set }
    var edges: [[E]] { get set }
    var isDAG: Bool { get }

    var vertexCount: Int { get }
    var edgeCount: Int { get }
    var immutableVertices: [V] { get }

    // MARK: Initializers

    init()
    init(vertices: [V])

    // MARK: Find

    func vertex(at index: Int) -> V
    func index(of vertex: V) -> Int?
    func indices(of a: V, _ b: V) -> (Int, Int)?

    func neighbors(for index: Int) -> [V]
    func neighbors(for vertex: V) -> [V]?
    func edges(for index: Int) -> [E]
    func edges(for vertex: V) -> [E]?

    func contains(vertex: V) -> Bool
    func contains(edge: E) -> Bool
    func edged(from: Int, to: Int) -> Bool
    func edged(from: V, to: V) -> Bool

    // MARK: Mutate

    mutating func add(vertex: V)
    mutating func add(edge: E)
    mutating func remove(at index: Int)
    mutating func remove(vertex: V)
    mutating func remove(edge: E)
    mutating func unedge(_ from: Int, to: Int, bidirectional: Bool)
    mutating func unedge(_ from: V, to: V, bidirectional: Bool)

    // edge(:to:) must be implemented in protocols that conform to `Graph`
    // according to the properties of its `E`. See `UnweightedGraph`.

    // MARK: Depth-First Search

    func dfs(from: Int, until test: (V) -> Bool) -> [E]
    func dfs(from: V, until test: (V) -> Bool) -> [E]
    func dfs(from: Int, to: Int) -> [E]
    func dfs(from: V, to: V) -> [E]

    // MARK: Breadth-First Search

    func bfs(from: Int, until test: (V) -> Bool) -> [E]
    func bfs(from: V, until test: (V) -> Bool) -> [E]
    func bfs(from: Int, to: Int) -> [E]
    func bfs(from: V, to: V) -> [E]

    // MARK: Search

    func routes(from: Int, until test: (V) -> Bool) -> [[E]]
    func routes(from: V, until test: (V) -> Bool) -> [[E]]

    func route(from: V, to: V, in path: [Int: E]) -> [E]
    func route(_ from: Int, _ to: Int, in path: [Int: E]) -> [E]

    func vertices(from edges: [E]) -> [V]

    // MARK: Cycle

    func cycles(until length: Int) -> [[V]]
    func cycles(until length: Int) -> [[E]]

    // MARK: Sort

    func topologicalSort() -> [V]?
}

extension Graph {
    /// How many vertices are in the graph?
    public var vertexCount: Int {
        return vertices.count
    }

    /// How many edges are in the graph?
    public var edgeCount: Int {
        return edges.joined().count
    }

    /// An immutable array containing all of the vertices in the graph.
    public var immutableVertices: [V] {
        return vertices
    }

    public init(vertices: [V]) {
        self.init()
        for vertex in vertices {
            add(vertex: vertex)
        }
    }
}

extension Graph {
    /// Get a vertex by its index.
    ///
    /// - parameter index: The index of the vertex.
    /// - returns: The vertex at i.
    public func vertex(at index: Int) -> V {
        return vertices[index]
    }

    /// Find the first occurence of a vertex if it exists.
    ///
    /// - parameter vertex: The vertex you are looking for.
    /// - returns: The index of the vertex. Return nil if it can't find it.
    public func index(of vertex: V) -> Int? {
        return vertices.index(of: vertex)
    }

    /// Finds the first the first occurence of two vertices. O(n).
    ///
    /// - parameter a: A vertex.
    /// - parameter b: A vertex.
    /// - returns: A tuple with the indices of the vertices, or nil.
    public func indices(of a: V, _ b: V) -> (Int, Int)? {
        guard let a = index(of: a), let b = index(of: b) else { return nil }
        return (a, b)
    }

    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of the neighbor vertices.
    public func neighbors(for index: Int) -> [V] {
        return edges[index].map { self.vertices[$0.v] }
    }

    /// Find all of the neighbors of a given Vertex.
    ///
    /// - parameter vertex: The vertex to find the neighbors of.
    /// - returns: An optional array of the neighbor vertices.
    public func neighbors(for vertex: V) -> [V]? {
        if let i = index(of: vertex) {
            return neighbors(for: i)
        }
        return nil
    }

    /// Find all of the edges of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the children of.
    public func edges(for index: Int) -> [E] {
        return edges[index]
    }

    /// Find all of the edges of a given vertex.
    ///
    /// - parameter vertex: The vertex to find the edges of.
    public func edges(for vertex: V) -> [E]? {
        if let i = index(of: vertex) {
            return edges(for: i)
        }
        return nil
    }

    /// Find the first occurence of a vertex.
    ///
    /// - parameter vertex: The vertex you are looking for.
    public func contains(vertex: V) -> Bool {
        if index(of: vertex) == nil { return false }
        return true
    }

    /// Find the first occurence of an edge.
    ///
    /// - parameter edge: The edge you are looking for.
    public func contains(edge: E) -> Bool {
        return edged(from: edge.u, to: edge.v)
    }

    /// Is there an edge from one vertex to another?
    ///
    /// - parameter from: The index of the starting edge.
    /// - parameter to: The index of the ending edge.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edged(from: Int, to: Int) -> Bool {
        return edges[from].map { $0.v }.contains(to)
    }

    /// Is there an edge from one vertex to another? Note this will look at the first
    /// occurence of each vertex. Also returns false if either of the supplied vertices
    /// cannot be found in the graph.
    ///
    /// - parameter from: The first vertex.
    /// - parameter to: The second vertex.
    /// - returns: A Bool that is true if such an edge exists, and false otherwise.
    public func edged(from: V, to: V) -> Bool {
        guard let (u, v) = indices(of: from, to) else { return false }
        return edged(from: u, to: v)
    }
}

extension Graph {
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added.
    public mutating func add(vertex: V) {
        _add(vertex, to: &self)
    }

    internal func _add(_ vertex: V, to graph: inout Self) {
        graph.vertices.append(vertex)
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

    /// Removes a vertex at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public mutating func remove(at index: Int) {
        _remove(at: index, from: &self)
    }

    internal func _remove(at index: Int, from graph: inout Self) {
        // remove all edges ending at the vertex, first doing the ones below it
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

        // remove all edges after the vertex index wise
        // renumber all edges after the vertex index wise
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
        // remove the actual vertex and its edges
        graph.edges.remove(at: index)
        graph.vertices.remove(at: index)
    }

    /// Removes the first occurence of a vertex, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter vertex: The vertex to be removed.
    public mutating func remove(vertex: V) {
        _remove(vertex: vertex, from: &self)
    }

    internal func _remove(vertex: V, from graph: inout Self) {
        if let i = index(of: vertex) {
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

    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
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

    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public mutating func unedge(_ from: V, to: V, bidirectional: Bool = true) {
        _unedge(from, to: to, bidirectional: bidirectional, from: &self)
    }

    internal func _unedge(_ from: V, to: V, bidirectional: Bool = true, from graph: inout Self) {
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

    /// Removes a vertex at a specified index, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public func remove(at index: Int) {
        var self_ = self
        _remove(at: index, from: &self_)
    }

    /// Removes the first occurence of a vertex, all of the edges attached to it,
    /// and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter vertex: The vertex to be removed.
    public func remove(vertex: V) {
        var self_ = self
        _remove(vertex: vertex, from: &self_)
    }

    /// Removes a specific unweighted edge in both directions (if it's not
    /// directional). Or just one way if it's directed.
    ///
    /// - parameter edge: The edge to be removed.
    public func remove(edge: E) {
        var self_ = self
        _remove(edge: edge, from: &self_)
    }

    /// Removes all edges in both directions between vertices at indexes from & to.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func unedge(_ from: Int, to: Int, bidirectional: Bool = true) {
        var self_ = self
        _unedge(from, to: to, bidirectional: bidirectional, from: &self_)
    }

    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func unedge(_ from: V, to: V, bidirectional: Bool = true) {
        var self_ = self
        _unedge(from, to: to, bidirectional: bidirectional, from: &self_)
    }
}

extension Graph { // Printable
    public var description: String {
        var d: String = ""
        for i in 0 ..< vertices.count {
            d += "\(vertices[i]) -> \(neighbors(for: i))\n"
        }
        return d
    }
}

extension Graph { // Collection
    public typealias Index = Int
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return vertexCount }

    public func index(after i: Index) -> Index { return i + 1 }
    public subscript(i: Int) -> V { return vertex(at: i) }
}
