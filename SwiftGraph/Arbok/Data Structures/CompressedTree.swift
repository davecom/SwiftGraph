import Foundation

internal final class CompressedTree<T> where T: AdditiveArithmetic {
    internal var parent: [Int]
    internal var value: [T]
    
    init(initialSize: Int) {
        self.parent = [Int].init(repeating: -1, count: initialSize)
        self.value = [T].init(repeating: T.zero, count: initialSize)
    }
    
    
    /// Finds the representative (alias, root) of the set that contains the element `element`.
    ///
    ///  - Parameter element: The index of the element to find the representative for.
    ///  - Returns: The index of the element that represents the set that contains `element`.
    ///
    ///  - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    func find(_ element: Int) -> Int {
        assert(element < parent.count)

        if parent[element] < 0 {
            return element
        } else {
            let root = find(parent[element])
            
            if parent[element] != root {
                value[element] += value[parent[element]]
            }
            
            parent[element] = root
            
            return root
        }
    }
    
    /// Increments the value of `element` by `T`.
    ///
    /// - Parameter element: The index of the element to increment
    /// - Parameter increment: The delta to increment the value of element of.
    func addValue(_ element: Int, increment: T) {
        value[find(element)] += increment
    }
    
    
    /// Determines the sum of the values associated with all the elements in the path from `root` of the set that contains `element` and `element` itself.
    ///
    /// - Parameter element: The index of the element to find the path compression value for.
    /// - Returns: Sum of the values from `find(element)` to `element`.
    ///
    /// - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    func findValue(_ element: Int) -> T {
        let root = self.find(element)
        
        return value[element] + (element != root ? value[root] : T.zero)
    }
    
    
    /// Performs the union by rank with path compression of the sets that contain `lhs` and `rhs` respectively, if they're not already in the same set.
    ///
    /// - Parameter lhs: The index of an element in the first set to join.
    /// - Parameter rhs: The index of an element in the second set to join.
    ///
    /// - Returns `false` if `lhs` and `rhs` already belonged to the same set and the union didn't produce any effect, `true` otherwise.
    ///  - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    @discardableResult func join(_ lhs: Int, _ rhs: Int) -> Bool {
        var lhsRoot = self.find(lhs)
        var rhsRoot = self.find(rhs)
        
        if lhsRoot == rhsRoot {
            return false
        } else {
            if parent[lhsRoot] > parent[rhsRoot] {
                swap(&lhsRoot, &rhsRoot)
            }
            
            parent[lhsRoot] += parent[rhsRoot]
            parent[rhsRoot] = lhsRoot
            value[rhsRoot] -= value[lhsRoot]
                        
            return true
        }
    }
    
    
    /// Tests wheter or not `lhs` and `rhs` belong to the same set.
    ///
    /// - Parameter lhs: The index of the first element.
    /// - Parameter rhs: The index of the second element.
    ///
    /// - Returns `true` if `lhs` and `rhs` are part of the same set, `false` otherwise.
    func same(_ lhs: Int, _ rhs: Int) -> Bool {
        return find(lhs) == find(rhs)
    }
    
    
    /// Computes the size of the subset that contains `element`.
    ///
    /// - Parameter element: The index of an element contained in the set to find the size for.
    func size(_ element: Int) -> Int {
        return -parent[find(element)]
    }
    
    /// Computes the size of this Disjoint Set Union, that is, the number of subsets.
    func size() -> Int {
        return self.parent.count
    }
}
