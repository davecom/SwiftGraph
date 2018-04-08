import XCTest
@testable import SwiftGraphTests

XCTMain([
    testCase(DijkstraGraphTests.allTests),
    testCase(MSTTests.allTests),
    testCase(SwiftGraphSearchTests.allTests),
    testCase(SwiftGraphSortTests.allTests),
    testCase(SwiftGraphTests.allTests),
    testCase(GraphEqualityTests.allTests),
    testCase(WeightedGraphEqualityTests.allTests),
    testCase(CycleTests.allTests),
])
