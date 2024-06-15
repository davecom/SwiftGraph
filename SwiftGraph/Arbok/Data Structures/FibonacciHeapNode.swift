import Foundation

internal final class Weak<T> where T: AnyObject {
    internal weak var wrappedValue: T?
    
    init(wrappedValue: T? = nil) {
        self.wrappedValue = wrappedValue
    }
}

internal final class FibonacciHeapNode<T> where T: AdditiveArithmetic {
    internal var from: Int
    internal var to: Int
    internal var weight: T
    internal var id: Int
    
    internal var parent: FibonacciHeapNode? = nil
    internal var children: LinkedList = LinkedList<FibonacciHeapNode>()
    internal var isLoser: Bool = false
    internal var list_it: LinkedList<FibonacciHeapNode>.LinkedListIndex?
    internal var superlists: [Weak<LinkedList<FibonacciHeapNode>>] = []
    
    init(from: Int, to: Int, weight: T, id: Int) {
        self.from = from
        self.to = to
        self.weight = weight
        self.id = id
    }    
}


extension FibonacciHeapNode: CustomStringConvertible {
    var description: String {
        return "[\(from) ---\(weight)---> \(to)]"
    }
}
