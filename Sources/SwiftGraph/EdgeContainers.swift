//
//  EdgeContainers.swift
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

/// An abstract edge container used to store the discovered edges whose destination vertex still
/// has to be visited.
public protocol EdgeContainer {
    associatedtype E

    /// Indicates wheter this container is a first-in-first-out container or a
    /// last-in-first-out container.
    ///
    /// This property indicates in which order the discovered vertices need to be added
    /// to the container container.
    ///
    /// If true, the container is a first-in-first-out container and
    /// the vertices that must be visited first, must be added first.
    /// If false, the container is a last-in-first-out container and
    /// the vertices that must be visited first, must be added last.
    static var isFIFO: Bool { get }

    init()
    func push(_ e: E)
    func pop() -> E
    var isEmpty: Bool { get }
}

/// Implements a stack - helper class that uses an array internally.
final public class Stack<T>: EdgeContainer {
    public var container: [T] = [T]()

    public static var isFIFO: Bool {
        @inline(__always) get { return false }
    }

    public required init() {}
    public var isEmpty: Bool {
        @inline(__always) get { return container.isEmpty }
    }
    @inline(__always) public func push(_ thing: T) { container.append(thing) }
    @inline(__always) public func pop() -> T { return container.removeLast() }
}

/// Implements a queue - helper class that uses an array internally.
final public class Queue<T: Equatable>: EdgeContainer {
    public var container: [T] = [T]()

    public static var isFIFO: Bool {
        @inline(__always) get { return true }
    }

    public required init() {}
    public var isEmpty: Bool {
        @inline(__always) get { return container.isEmpty }
    }
    public var count: Int {
        @inline(__always) get { return container.count }
    }
    @inline(__always) public func push(_ thing: T) { container.append(thing) }
    @inline(__always) public func pop() -> T { return container.remove(at: 0) }
    @inline(__always) public func contains(_ thing: T) -> Bool {
        if container.index(of: thing) != nil {
            return true
        }
        return false
    }
}
