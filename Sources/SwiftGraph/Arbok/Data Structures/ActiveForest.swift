import Foundation

internal final class ActiveForest<T> where T: AdditiveArithmetic & Comparable {
    internal let co: CompressedTree<T>
    internal var activeEdge: [FibonacciHeapNode<T>?] // for each node the active outgoing edge
    internal var activeSets: [LinkedList<FibonacciHeapNode<T>>] // for each node on path the active set heap represented by the root list
    
    init(co: CompressedTree<T>) {
        self.co = co
        self.activeEdge = .init(repeating: nil, count: co.size())
        self.activeSets = []
        
        // activeSets.reserveCapacity(co.size())
        
        for _ in 0..<co.size() {
            activeSets.append(LinkedList<FibonacciHeapNode>())
        }
    }
    
    // MARK: - ACTIVE FORESTS METHODS
    
    /// - Complexity: O(activeSets.count)
    internal func mergeHeaps(_ lhs: Int, _ rhs: Int) {
        
        let rhsList = self.activeSets[rhs]
        
        self.activeSets[lhs].append(rhsList)
        rhsList.removeAll()
    }

    
    /// - Complexity: O(α(n) · `self.activeEdge[edge].count` + Cost(`removeFromCurrentList(self.activeEdge[edge])` ,
    /// where α(n) is the inverse Ackermann function. Approximately linear
    internal func deleteActiveEdge(_ edge: Int) {
        guard let vertex = self.activeEdge[edge] else { fatalError() }
        
        vertex.children.forEach { child in
            self.moveHome(child)
        }
        
        vertex.children.removeAll()
        
        self.removeFromCurrentList(vertex)

        self.activeEdge[edge] = nil
        
        // delete v
    }
    
    
    internal func getMin(_ index: Int) -> Int {
        var orderRep = [FibonacciHeapNode<T>?].init()
        
        activeSets[index].forEach { v in
            var vertex = v
            
            vertex.isLoser = false
            
            // vertex.children.count changes during the while loop
            let _ = vertex.children.count() // Refresh vertex.children.underestimatedCount
            
            while orderRep.count > vertex.children.underestimatedCount && orderRep[vertex.children.underestimatedCount] != nil {

                guard var other = orderRep[vertex.children.underestimatedCount] else { fatalError() }

                orderRep[vertex.children.underestimatedCount] = nil

                if self.currentWeight(of: other) < self.currentWeight(of: vertex) {
                    swap(&vertex, &other)
                }
                
                #if DEBUG
                    assert(other.parent == nil)
                #endif
                
                                
                other.list_it = vertex.children.append(other)
                other.parent = vertex
                
                #if DEBUG
                    assert(vertex !== other)
                    assert(other.list_it?.getOwner() === vertex.children)
                #endif
            }
            
            orderRep.append(contentsOf: [FibonacciHeapNode?].init(
                repeating: nil,
                count: max(0, vertex.children.underestimatedCount+1 - orderRep.count)
            ))
            
            orderRep[vertex.children.underestimatedCount] = vertex
        }

        activeSets[index].removeAll()
                
        orderRep.forEach { vertex in
            if let vertex = vertex {
                vertex.list_it = activeSets[index].append(vertex)
            }
        }
        
        #if DEBUG
        assert(!activeSets[index].isEmpty)
        #endif
                
        let vMin = activeSets[index].min { lhs, rhs in
            return self.currentWeight(of: lhs) < self.currentWeight(of: rhs)
        }
        
        #if DEBUG
            assert(vMin != nil)
            assert(co.find(vMin!.to) == index, "\(vMin!.to) expected in home heap \(index), found in \(co.find(vMin!.to)) instead")
            assert(activeEdge[co.find(vMin!.from)] != nil)
            assert(vMin! === activeEdge[co.find(vMin!.from)], "edge must be active!") // FIXME: It happened that activeEdge[co.find(vMin!.from)] == nil
        #endif
         
        return vMin!.id
    }
    
    
    internal func makeActive(from: Int, to: Int, weight: T, id: Int) {
        let fromRep = co.find(from)
        
        if activeEdge[fromRep] == nil {
            activeEdge[fromRep] = FibonacciHeapNode(from: from, to: to, weight: weight, id: id)
            moveHome(activeEdge[fromRep]!)
            return
        }
                
        guard let vertex = activeEdge[fromRep] else { fatalError() }
        
        #if DEBUG
            assert(
                weight + self.co.findValue(to) < self.currentWeight(of: vertex) ||
                co.find(to) != co.find(vertex.to)
            )
        #endif
        
        self.removeFromCurrentList(vertex)
        vertex.to = to
        vertex.weight = weight
        vertex.id = id
        vertex.from = from

        self.moveHome(vertex)
    }

    
    // MARK: - FIBONACCI HEAP METHODS
    
    /// - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    internal func homeHeap(_ vertex: FibonacciHeapNode<T>) -> LinkedList<FibonacciHeapNode<T>> {
        return activeSets[co.find(vertex.to)]
    }
    
    /// - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    internal func moveHome(_ vertex: FibonacciHeapNode<T>) {
        let home = self.homeHeap(vertex)
            
        
        #if DEBUG
        assert(!home.find(where: { node in
            return node === vertex
        }))
        #endif
         
        vertex.list_it = home.append(vertex)
        vertex.parent = nil
    }
        
    
    /// - Complexity: O(α(n))·Cost(`loseChild(vertex.parent)`), where α(n) is the inverse Ackermann function
    internal func loseChild(_ vertex: FibonacciHeapNode<T>) {
        guard let parent = vertex.parent else { return }
        
        if vertex.isLoser {
            self.loseChild(parent)
            
            #if DEBUG
            assert(vertex.list_it?.getOwner() === vertex.parent?.children)
            #endif
            
            vertex.list_it?.removeFromOwnerList()
            self.moveHome(vertex)
        }
        
        vertex.isLoser.toggle()
    }
    
    
    /// - Complexity: O( α(n) + n + m ) where `n = vertex.parent?.children.count` and `m = self.homeHeap(vertex).count`, and
    /// α(n) is the inverse Ackermann function
    internal func removeFromCurrentList(_ vertex: FibonacciHeapNode<T>) {
        let list = vertex.parent != nil ? vertex.parent?.children : self.homeHeap(vertex)
        
        #if DEBUG
            // Assert that `list` contains the parameter `vertex`
            assert(list != nil)
            assert(vertex.list_it != nil)
            assert(vertex.list_it?.getNode() != nil)
        
            assert(list?.find { node in
                return node === vertex
            } ?? false)
        #endif
        
        list?.removeAll { edge in
            return edge.id == vertex.id
        }
        
        if let parent = vertex.parent {
            self.loseChild(parent)
            vertex.parent = nil
        }
    }
    
    /// - Complexity: O(α(n)), where α(n) is the inverse Ackermann function
    internal func currentWeight(of vertex: FibonacciHeapNode<T>) -> T {
        let retval = vertex.weight + self.co.findValue(vertex.to)
        
        return retval
    }
}
