/// Adjusted interface fot LinkedList from https://github.com/kodecocodes/swift-algorithm-club to
/// achieve O(1) insertion and removal (except at `index > 0` and `index < list.count() - 1` ), and always O(1)
/// when the node is passed directly as an argument.
import os

internal final class LinkedList<T> {
    
    /// Linked List's Node Class Declaration
    public class LinkedListNode {
        
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        public init(value: T) {
            self.value = value
        }
    }
    
    
    /// Typealiasing the node class to increase readability of code
    public typealias Node = LinkedListNode
    
        /// The head of the Linked List
    private(set) var head: Node?
    private(set) weak var tail: Node?
    internal var underestimatedCount: Int = 0
        
    /// Computed property to check if the linked list is empty
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// Default initializer
    public init() {}
    
    
    /// Subscript function to return the node at a specific index
    ///
    /// - Parameter index: Integer value of the requested value's index
    /// - Complexity: ϴ( min(index, count) ), O(count)
    public subscript(index: Int) -> LinkedListNode {
        return self.node(at: index)
    }
    
    /// Function to return the node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameter index: Integer value of the node's index to be returned
    /// - Returns: LinkedListNode
    /// - Complexity: ϴ( min(index, count) ), O(count)
    public func node(at index: Int) -> Node {
        assert(head != nil, "List is empty")
        assert(index >= 0, "index must be greater or equal to 0")
        
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            
            assert(node != nil, "index is out of bounds.")
            return node!
        }
    }
    
    /// Append a value to the end of the list
    ///
    /// - Parameter value: The data value to be appended
    /// - Returns: An iterator to the added node, whose tag is the number of elements after the insertion, minus one.
    /// - Complexity: O(1)
    @discardableResult public func append(_ value: T) -> LinkedListIndex {
        let newNode = Node(value: value)
        
        return append(newNode)
    }
    
    /// Append a copy of a LinkedListNode to the end of the list.
    ///
    /// - Parameter node: The node containing the value to be appended
    /// - Returns: An iterator to the added node, whose tag is the number of elements after the insertion, minus one.
    /// - Complexity: O(1)
    @discardableResult public func append(_ node: Node) -> LinkedListIndex {
        let newNode = node
        
        if let tail = self.tail {
            newNode.previous = tail
            self.tail?.next = newNode
            self.tail = newNode
        } else {
            head = newNode
            self.tail = newNode
        }
        
        self.underestimatedCount += 1
        
        return LinkedListIndex(
            owner: self,
            node: newNode,
            tag: self.underestimatedCount - 1
        )
    }
    
    
    /// Append a copy of a LinkedList to the end of the list.
    ///
    ///  - Note: This implementation performs a shallow copy, the referenced objects in the new list are the same as those in `list` parameter.
    ///
    /// - Parameter list: The list to be copied and appended.
    /// - Returns: An iterator to the head of the appended list, whose tag is the number of elements of this list before the insertion, minus one.
    ///
    /// - Complexity: O(count + list.count)
    @discardableResult public func append(
        _ list: LinkedList,
        didCopy: (
            (_ from: LinkedList<T>,
             _ to: LinkedList<T>,
             _ of: T
            ) -> Void)? = nil
    ) -> LinkedListIndex {
        let initialCount = self.underestimatedCount
        
        if list === self {

            let clonedList = LinkedList()
            self.forEach { value in
                clonedList.append(value)
            }
            
            return self.append(clonedList)
        } else {
            list.forEach { valueToClone in
                self.append(valueToClone)
                didCopy?(list, self, valueToClone)
            }
                        
            return LinkedListIndex(
                owner: self,
                node: list.head,
                tag: initialCount - 1
            )
        }
    }
    
    
    
    
    /// Insert a value at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - value: The data value to be inserted
    ///   - index: Integer value of the index to be insterted at
    /// - Returns: An iterator to the head of the appended list, whose tag is the 0-based position of the head of the new list after the insertion.
    /// - Complexity: O(count)
    @discardableResult public func insert(_ value: T, at index: Int) -> LinkedListIndex {
        let newNode = Node(value: value)
        return insert(newNode, at: index)
    }
    
    /// Insert a copy of a node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - node: The node containing the value to be inserted
    ///   - index: Integer value of the index to be inserted at
    /// - Returns: An iterator to the added node, whose tag is the parameter `index`.
    /// - Complexity: O(count)
    @discardableResult public func insert(_ newNode: Node, at index: Int) -> LinkedListIndex {
        assert(index >= 0, "in function \(#function), parameter `index` is expected to satisfy (index >= 0)")
        assert(index <= self.count, "in function \(#function), parameter `index` is expected to satisfy (index <= \(self.count)")
        
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            if index == self.count {
                newNode.previous = self.tail
                self.tail?.next = newNode
                self.tail = newNode
            } else {
                let prev = node(at: index - 1)
                let next = prev.next
                newNode.previous = prev
                newNode.next = next
                next?.previous = newNode
                prev.next = newNode
            }
        }
        
        self.underestimatedCount += 1
        
        return LinkedListIndex(owner: self, node: newNode, tag: index)
    }
    
    /// Insert a copy of a LinkedList at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - list: The LinkedList to be copied and inserted
    ///   - index: Integer value of the index to be inserted at
    /// - Returns: An iterator to the head of the appended list, whose tag is the 0-based position of the head of the new list after the insertion.
    /// - Complexity: O(count + list.count)
    public func insert(_ list: LinkedList, at index: Int) -> LinkedListIndex {
        guard !list.isEmpty else { return LinkedListIndex(owner: self, node: nil, tag: -1)}
                
        if index == 0 {
            list.tail?.next = head
            head = list.head
        } else {
            let prev = index == self.count ? self.tail : node(at: index - 1)
            let next = prev?.next
            
            prev?.next = list.head
            list.head?.previous = prev
            
            list.tail?.next = next
            next?.previous = list.tail
        }
        
        self.underestimatedCount += list.underestimatedCount
     
        return LinkedListIndex(owner: self, node: list.head, tag: index)
    }
    
    
    // FIXME: As for C++ docs: All iterators, references and pointers related to this container are invalidated, except the end iterators.

    /// Function to remove all nodes/value from the list
    ///
    /// - Complexity: O(1)
    public func removeAll() {
        guard self.head != nil else { return }
        
        /*
        var current = self.head
        var previous = self.head
        
        while current != nil {
            previous = current
            
            current = current?.next
            previous?.next = nil
            previous?.previous = nil
        }
        
        #if DEBUG
        assert(self.count() == 1, "count: \(self.count()) after removing all the elements in the list. 1 expected.")
        #endif
        */
        head = nil
        tail = nil
                
        self.underestimatedCount = 0
    }
    
    
    public func removeAll(where predicate: (T) -> Bool, safe: Bool = false) {
        var nodesToRemove = [LinkedList<T>.LinkedListNode].init()
        
        self.forEachNode { node in
            if predicate(node.value) {
                nodesToRemove.append(node)
            }
        }
        
        for i in 0..<nodesToRemove.count {
            self.remove(node: nodesToRemove[i], safe: safe)
        }
    }
    
    /// Function to remove a specific node.
    ///
    /// - Parameter node: The node to be deleted
    /// - Returns: The data value contained in the deleted node.
    ///
    /// - Complexity: O(count) if `safe` is true, to check if the node to remove is actually part of the list. O(1) if `safe` is false.
    @discardableResult public func remove(node: Node, safe: Bool = false) -> T? {
        if safe {
            if !self.find(node) {
                return nil
            }
        }
        
        if node === head {
            if head === tail {
                self.head = self.head?.next
                self.tail = self.head
            } else {
                self.head = self.head?.next
            }
        } else {
            if node === tail {
                self.tail = node.previous
                self.tail?.next = nil
            } else {
                let prev = node.previous
                let next = node.next
                
                if let prev = prev {
                    prev.next = next
                } else {
                    head = next
                }
                next?.previous = prev
            }
        }
        
        self.underestimatedCount -= 1
        
        node.previous = nil
        node.next = nil

        
        return node.value
    }
    
    
    /// Function to test whether or not some node is contained in this list. Two nodes in the list are considered to be the same if and only if they point to the same object in memory.
    ///
    /// - Parameter node: The node to find in this list.
    /// - Returns: `true` if `node` is included in this list, `false` otherwise.
    ///
    /// - Complexity: O(self.count)
    internal func find(_ node: Node) -> Bool {
        var current = self.head
        
        while current != nil {
            if node === current {
                return true
            }
            
            current = current?.next
        }
        
        return false
    }
    
    
    /// Tests whether or not an element satisfying the given predicate exists in the linkedlist.
    ///
    /// - Parameter where: A function that takes as input a value and returns a boolean
    /// - Returns: `true` if at least one element satisfying the predicate exists in the list, `false` otherwise.
    ///
    /// - Complexity: O(self.count)
    internal func find(where test: @escaping (T) -> Bool ) -> Bool {
        var current = self.head
        
        while current != nil {
            guard let currentListItem = current else { return false }
            if test(currentListItem.value) {
                return true
            }
            
            current = currentListItem.next
        }
        
        return false
    }
    
    /// Finds the first element in the list satisfying the given predicate in the linkedlist, if it exists.
    ///
    /// - Parameter where: A function that takes as input a value and returns a boolean
    /// - Returns: A `LinkedListIndex` to the found element, whose tag is the current position of the item in the list,
    ///    if at least one element satisfying the `where` predicate exists. `nil` otherwise.
    ///
    /// - Complexity: O(self.count)
    internal func findFirst(where test: @escaping (T) -> Bool ) -> LinkedListIndex? {
        var current = self.head
        var count: Int = 0
        
        while current != nil {
            guard let currentListItem = current else { return nil }
            count += 1
            
            if test(currentListItem.value) {
                return LinkedListIndex(
                    owner: self,
                    node: current,
                    tag: count
                )
            }
            
            current = currentListItem.next
        }
        
        return nil
    }

    
    /// Function to remove the last node/value in the list. Crashes if the list is empty
    ///
    /// - Returns: The data value contained in the deleted node.
    /// - Complexity: O(1)
    @discardableResult public func removeLast() -> T {
        assert(!isEmpty, "In function \(#function), attempted to remove last element from an empty list. Aborting.")
        guard let tail = self.tail else {
            #if DEBUG
            fatalError("In function \(#function), attempted to remove last element from an empty list. Aborting.")
            #endif
        }
        
        let removedValue = remove(node: tail)
        
        assert(removedValue != nil)
        return removedValue!
    }
    
    /// Function to remove a node/value at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameter index: Integer value of the index of the node to be removed
    /// - Returns: The data value contained in the deleted node
    /// - Complexity: O(count)
    @discardableResult public func remove(at index: Int) -> T {
        let node = self.node(at: index)
        let removedValue = remove(node: node)
        
        assert(removedValue != nil)
        return removedValue!
    }
    
    /// Counts the actual number of elements in the list. It refreshes underestimated count to the correct value.
    ///
    /// - Complexity: O(count)
    public func count() -> Int {
        var count = 0
        var current = self.head
        
        while current != nil {
            count += 1
            current = current?.next
        }
        
        self.underestimatedCount = count
        
        return count
    }
}

//: End of the base class declarations & beginning of extensions' declarations:

// MARK: - Extension to enable the standard conversion of a list to String
extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        while let nd = node {
            s += "\(nd.value)"
            node = nd.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

// MARK: - Extension to add a 'reverse' function to the list
extension LinkedList {
    public func reverse() {
        var node = head
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
}

// MARK: - An extension with an implementation of 'map' & 'filter' functions
extension LinkedList {
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while let nd = node {
            result.append(transform(nd.value))
            node = nd.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList {
        let result = LinkedList<T>()
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result.append(nd.value)
            }
            node = nd.next
        }
        return result
    }
}

// MARK: - Extension to enable initialization from an Array
extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()
        
        array.forEach { append($0) }
    }
}

// MARK: - Extension to enable initialization from an Array Literal
extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        
        elements.forEach { append($0) }
    }
}

// MARK: - Collection
extension LinkedList: Collection {
    
    public typealias Index = LinkedListIndex
    
    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    /// - Complexity: O(1)
    public var startIndex: Index {
        get {
            return LinkedListIndex(owner: self, node: head, tag: 0)
        }
    }
    
    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    /// - Complexity: O(1), where n is the number of elements in the list. This can be improved by keeping a reference
    ///   to the last node in the collection.
    public var endIndex: Index {
        get {
            return LinkedListIndex(node: self.tail, tag: self.underestimatedCount)
        }
    }
    
    public subscript(position: Index) -> T {
        get {
            return position.node!.value
        }
    }
    
    public func index(after idx: Index) -> Index {
        return LinkedListIndex(owner: self, node: idx.node?.next, tag: idx.tag + 1)
    }
    
    
    /// Converts the list to an array of T.
    ///
    /// - Complexity: O(count)
    internal func toArray() -> [T] {
        var current = self.head
        var array = [T].init()
        
        while current != nil {
            if let value = current?.value {
                array.append(value)
            }
            
            current = current?.next
        }
        
        return array
    }
    
    /// Makes an iterator to the list, pointing to the head element of the list
    internal func iterator() -> LinkedListIndex {
        return LinkedListIndex(
            owner: self,
            node: self.head,
            tag: 0
        )
    }
    
    internal func endListIndex() -> LinkedListIndex {
        return LinkedListIndex(
            owner: self,
            node: self.tail,
            tag: self.underestimatedCount - 1
        )
    }
    
    
    // MARK: - Collection Index
    /// Custom index type that contains a reference to the node at index 'tag'
    public struct LinkedListIndex: Comparable {
        fileprivate weak var owner: LinkedList<T>?
        fileprivate var node: LinkedList<T>.LinkedListNode?
        fileprivate let tag: Int
        
        internal init(owner: LinkedList<T>? = nil, node: LinkedList<T>.LinkedListNode? = nil, tag: Int) {
            self.owner = owner
            self.node = node
            self.tag = tag
        }
        
        public static func==(lhs: LinkedListIndex, rhs: LinkedListIndex) -> Bool {
            return (lhs.tag == rhs.tag)
        }
        
        public static func< (lhs: LinkedListIndex, rhs: LinkedListIndex) -> Bool {
            return (lhs.tag < rhs.tag)
        }
        
        internal func getNode() -> LinkedList<T>.LinkedListNode? {
            return self.node
        }
        
        internal func getValue() -> T? {
            return self.node?.value
        }
        
        internal mutating func updateOwner(_ to: LinkedList<T>) {
            self.owner = to
        }
        
        internal func getTag() -> Int {
            return self.tag
        }
        
        internal func removeFromOwnerList() {
            
            guard let owner = self.owner else {
                fatalError()
            }
            
            guard let node = self.node else {
                fatalError()
            }
            
            #if DEBUG
                owner.remove(node: node, safe: true)
            #else
                owner.remove(node: node)
            #endif
        }
        
        internal func next() -> LinkedListIndex {
            return LinkedListIndex(
                owner: self.owner,
                node: self.node?.next,
                tag: self.tag + 1
            )
        }
        
        internal func previous() -> LinkedListIndex {
            return LinkedListIndex(
                owner: self.owner,
                node: self.node?.previous,
                tag: self.tag - 1
            )
        }
        
        internal func getOwner() -> LinkedList<T>? {
            return self.owner
        }
        
        mutating internal func movedToList(_ theList: LinkedList<T>) {
            self.owner = theList
        }
        
        /// - Returns: `true` if this index has the same as the right-hand side index,
        ///  and the referenced nodes by the two index are the same objects in memory.
        ///
        /// - Complexity: O(1)
        internal func isSame(as other: LinkedListIndex?) -> Bool {
            guard let other = other else { return false }
            return self.node === other.node && self.owner === other.owner
        }
    }
}



extension LinkedList {
    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEach(_ body: (T) throws -> Void) rethrows {
        var current = head
        
        while let currentNode = current {
            try body(currentNode.value)
            
            current = current?.next
        }
    }

    
    
    /// Calls the given closure on each element in the sequence in the same order
    /// as a `for`-`in` loop.
    ///
    /// The two loops in the following example produce the same output:
    ///
    ///     let numberWords = ["one", "two", "three"]
    ///     for word in numberWords {
    ///         print(word)
    ///     }
    ///     // Prints "one"
    ///     // Prints "two"
    ///     // Prints "three"
    ///
    ///     numberWords.forEach { word in
    ///         print(word)
    ///     }
    ///     // Same as above
    ///
    /// Using the `forEach` method is distinct from a `for`-`in` loop in two
    /// important ways:
    ///
    /// 1. You cannot use a `break` or `continue` statement to exit the current
    ///    call of the `body` closure or skip subsequent calls.
    /// 2. Using the `return` statement in the `body` closure will exit only from
    ///    the current call to `body`, not from any outer scope, and won't skip
    ///    subsequent calls.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a
    ///   parameter.
    @inlinable public func forEachNode(_ body: (LinkedListNode) throws -> Void) rethrows {
        var current = head
        
        while current != nil {
            if let current = current {
                try body(current)
            }
        
            current = current?.next
        }
    }
}

extension LinkedList.LinkedListNode where T: CustomStringConvertible {
    var description: String {
        return "current: \(self.value), previous: \(self.previous != nil ? String(describing: self.previous!.value) : "none"), next: \(self.next != nil ? String(describing: self.next!.value) : "none")"
    }
}
