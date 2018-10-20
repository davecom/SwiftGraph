import XCTest

extension ConstructorsPerformanceTests {
    static let __allTests = [
        ("testCompleteGraphConstructor", testCompleteGraphConstructor),
        ("testCycleUniqueElementsGraphConstructor", testCycleUniqueElementsGraphConstructor),
        ("testCycleUniqueElementsHashableConstructor", testCycleUniqueElementsHashableConstructor),
        ("testCycleUnweightedGraphConstructor", testCycleUnweightedGraphConstructor),
        ("testPathUniqueElementsGraphConstructor", testPathUniqueElementsGraphConstructor),
        ("testPathUniqueElementsGraphHashableConstructor", testPathUniqueElementsGraphHashableConstructor),
        ("testPathUnweightedGraphConstructor", testPathUnweightedGraphConstructor),
        ("testStarGraphConstructor", testStarGraphConstructor),
    ]
}

extension SearchPerformanceTests {
    static let __allTests = [
        ("testDfsInStarGraph", testDfsInStarGraph),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ConstructorsPerformanceTests.__allTests),
        testCase(SearchPerformanceTests.__allTests),
    ]
}
#endif
