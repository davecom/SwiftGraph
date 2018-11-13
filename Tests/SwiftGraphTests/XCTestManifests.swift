import XCTest

extension ConstructorsTests {
    static let __allTests = [
        ("testCompleteGraphConstructor", testCompleteGraphConstructor),
        ("testEmptyCompleteGraphConstructor", testEmptyCompleteGraphConstructor),
        ("testSingletonCompleteGraphConstructor", testSingletonCompleteGraphConstructor),
        ("testSingletonStarGraphConstructor", testSingletonStarGraphConstructor),
        ("testStarGraphConstructor", testStarGraphConstructor),
    ]
}

extension CycleTests {
    static let __allTests = [
        ("testDetectCyclesEdges1", testDetectCyclesEdges1),
        ("testDetectCyclesVertices1", testDetectCyclesVertices1),
        ("testFullyConnectedEdges", testFullyConnectedEdges),
        ("testFullyConnectedVertices", testFullyConnectedVertices),
    ]
}

extension DijkstraGraphTests {
    static let __allTests = [
        ("testDijkstra1", testDijkstra1),
        ("testDijkstra2", testDijkstra2),
        ("testDijkstra3", testDijkstra3),
        ("testRemovalWithDijkstra", testRemovalWithDijkstra),
    ]
}

extension MSTTests {
    static let __allTests = [
        ("testMST1", testMST1),
        ("testMST2", testMST2),
    ]
}

extension SwiftGraphCodableTests {
    static let __allTests = [
        ("testComplexWeightedEncodableDecodable", testComplexWeightedEncodableDecodable),
        ("testEncodableDecodable", testEncodableDecodable),
    ]
}

extension SwiftGraphSearchTests {
    static let __allTests = [
        ("testBFS1", testBFS1),
        ("testBFS2", testBFS2),
        ("testBFS3", testBFS3),
        ("testBFS4", testBFS4),
        ("testBFS5", testBFS5),
        ("testBFS6", testBFS6),
        ("testBFSWithCycle", testBFSWithCycle),
        ("testDFS1", testDFS1),
        ("testDFS2", testDFS2),
        ("testDFS3", testDFS3),
        ("testDFS4", testDFS4),
        ("testDFS5", testDFS5),
        ("testDFS6", testDFS6),
        ("testDfsDoesntVisitTwice", testDfsDoesntVisitTwice),
        ("testDFSNotFound", testDFSNotFound),
        ("testDFSWithCycle", testDFSWithCycle),
        ("testFindAllBfs", testFindAllBfs),
        ("testFindAllDfs", testFindAllDfs),
    ]
}

extension SwiftGraphSortTests {
    static let __allTests = [
        ("testDAG", testDAG),
        ("testTopologicalSort", testTopologicalSort),
    ]
}

extension SwiftGraphTests {
    static let __allTests = [
        ("testCitesInverseAfterRemove", testCitesInverseAfterRemove),
        ("testCounts", testCounts),
        ("testRemoveAllEdges", testRemoveAllEdges),
        ("testSequenceTypeAndCollectionType", testSequenceTypeAndCollectionType),
        ("testSubscript", testSubscript),
    ]
}

extension UnionTests {
    static let __allTests = [
        ("testAssociativity", testAssociativity),
        ("testCommutativity", testCommutativity),
        ("testDisjointUnion", testDisjointUnion),
        ("testEmptyGraph", testEmptyGraph),
        ("testIdentityEmptyGraph", testIdentityEmptyGraph),
        ("testImmutabilityOfInputGraphs", testImmutabilityOfInputGraphs),
        ("testMultipleParameters", testMultipleParameters),
        ("testUnionFirstInCommon", testUnionFirstInCommon),
        ("testUnionLastInCommon", testUnionLastInCommon),
        ("testUnionWithSelf", testUnionWithSelf),
    ]
}

extension UniqueElementsGraphHashableInitTests {
    static let __allTests = [
        ("testCycleInitializerDirected", testCycleInitializerDirected),
        ("testCycleInitializerUndirected", testCycleInitializerUndirected),
        ("testPathInitializerDirected", testPathInitializerDirected),
        ("testPathInitializerUndirected", testPathInitializerUndirected),
    ]
}

extension UniqueElementsGraphHashableTests {
    static let __allTests = [
        ("testUniqueDirectedEdges", testUniqueDirectedEdges),
        ("testUniqueDirectedLoop", testUniqueDirectedLoop),
        ("testUniqueDirectedLoop2", testUniqueDirectedLoop2),
        ("testUniqueEdgesCombined", testUniqueEdgesCombined),
        ("testUniqueUndirectedEdges", testUniqueUndirectedEdges),
        ("testUniqueUndirectedEdges2", testUniqueUndirectedEdges2),
        ("testUniqueUndirectedLoop", testUniqueUndirectedLoop),
        ("testUniqueUndirectedLoop2", testUniqueUndirectedLoop2),
        ("testUniqueVertexAfterAddition", testUniqueVertexAfterAddition),
        ("testUniqueVertexAfterInit", testUniqueVertexAfterInit),
    ]
}

extension UniqueElementsGraphInitTests {
    static let __allTests = [
        ("testCycleInitializerDirected", testCycleInitializerDirected),
        ("testCycleInitializerUndirected", testCycleInitializerUndirected),
        ("testPathInitializerDirected", testPathInitializerDirected),
        ("testPathInitializerUndirected", testPathInitializerUndirected),
    ]
}

extension UniqueElementsGraphTests {
    static let __allTests = [
        ("testUniqueDirectedEdges", testUniqueDirectedEdges),
        ("testUniqueDirectedLoop", testUniqueDirectedLoop),
        ("testUniqueDirectedLoop2", testUniqueDirectedLoop2),
        ("testUniqueEdgesCombined", testUniqueEdgesCombined),
        ("testUniqueUndirectedEdges", testUniqueUndirectedEdges),
        ("testUniqueUndirectedEdges2", testUniqueUndirectedEdges2),
        ("testUniqueUndirectedLoop", testUniqueUndirectedLoop),
        ("testUniqueUndirectedLoop2", testUniqueUndirectedLoop2),
        ("testUniqueVertexAfterAddition", testUniqueVertexAfterAddition),
        ("testUniqueVertexAfterInit", testUniqueVertexAfterInit),
    ]
}

extension UnweightedGraphTests {
    static let __allTests = [
        ("testCycleInitializerDirected", testCycleInitializerDirected),
        ("testCycleInitializerUndirected", testCycleInitializerUndirected),
        ("testPathInitializerDirected", testPathInitializerDirected),
        ("testPathInitializerUndirected", testPathInitializerUndirected),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConstructorsTests.__allTests),
        testCase(CycleTests.__allTests),
        testCase(DijkstraGraphTests.__allTests),
        testCase(MSTTests.__allTests),
        testCase(SwiftGraphCodableTests.__allTests),
        testCase(SwiftGraphSearchTests.__allTests),
        testCase(SwiftGraphSortTests.__allTests),
        testCase(SwiftGraphTests.__allTests),
        testCase(UnionTests.__allTests),
        testCase(UniqueElementsGraphHashableInitTests.__allTests),
        testCase(UniqueElementsGraphHashableTests.__allTests),
        testCase(UniqueElementsGraphInitTests.__allTests),
        testCase(UniqueElementsGraphTests.__allTests),
        testCase(UnweightedGraphTests.__allTests),
    ]
}
#endif
