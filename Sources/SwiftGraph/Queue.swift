//
//  Queue.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2019 David Kopec
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

/// Implements a queue - helper class that uses an array internally.
public class Queue<T> {
    private var container = [T]()
    private var head = 0

    public init() {}

    public var isEmpty: Bool {
        return count == 0
    }

    public func push(_ element: T) {
        container.append(element)
    }

    public func pop() -> T {
        let element = container[head]
        head += 1

        // If queue has more than 50 elements and more than 50% of allocated elements are popped.
        // Don't calculate the percentage with floating point, it decreases the performance considerably.
        if container.count > 50 && head * 2 > container.count {
            container.removeFirst(head)
            head = 0
        }

        return element
    }

    public var front: T {
        return container[head]
    }

    public var count: Int {
        return container.count - head
    }
}

extension Queue where T: Equatable {
    public func contains(_ thing: T) -> Bool {
        let content = container.dropFirst(head)
        if content.firstIndex(of: thing) != nil {
            return true
        }
        return false
    }
}

