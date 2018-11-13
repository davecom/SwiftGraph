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
        ("testBfsInCompleteGraphWithGoalTest", testBfsInCompleteGraphWithGoalTest),
        ("testBfsInCompleteGraphWithGoalTestByIndex", testBfsInCompleteGraphWithGoalTestByIndex),
        ("testBfsInPath", testBfsInPath),
        ("testBfsInPathByIndex", testBfsInPathByIndex),
        ("testBfsInPathWithGoalTest", testBfsInPathWithGoalTest),
        ("testBfsInPathWithGoalTestByIndex", testBfsInPathWithGoalTestByIndex),
        ("testBfsInStarGraph", testBfsInStarGraph),
        ("testBfsInStarGraphByIndex", testBfsInStarGraphByIndex),
        ("testBfsInStarGraphWithGoalTest", testBfsInStarGraphWithGoalTest),
        ("testBfsInStarGraphWithGoalTestByIndex", testBfsInStarGraphWithGoalTestByIndex),
        ("testDfsInCompleteGraphWithGoalTest", testDfsInCompleteGraphWithGoalTest),
        ("testDfsInCompleteGraphWithGoalTestByIndex", testDfsInCompleteGraphWithGoalTestByIndex),
        ("testDfsInPath", testDfsInPath),
        ("testDfsInPathByIndex", testDfsInPathByIndex),
        ("testDfsInPathWithGoalTest", testDfsInPathWithGoalTest),
        ("testDfsInPathWithGoalTestByIndex", testDfsInPathWithGoalTestByIndex),
        ("testDfsInStarGraph", testDfsInStarGraph),
        ("testDfsInStarGraphByIndex", testDfsInStarGraphByIndex),
        ("testDfsInStarGraphWithGoalTest", testDfsInStarGraphWithGoalTest),
        ("testDfsInStarGraphWithGoalTestByIndex", testDfsInStarGraphWithGoalTestByIndex),
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
