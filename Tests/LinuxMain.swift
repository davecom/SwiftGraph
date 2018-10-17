import XCTest
@testable import SwiftGraphTests
@testable import SwiftGraphPerformanceTests

XCTMain([
    testCase(DijkstraGraphTests.allTests),
    testCase(MSTTests.allTests),
    testCase(SwiftGraphSearchTests.allTests),
    testCase(SwiftGraphSortTests.allTests),
    testCase(SwiftGraphTests.allTests),
    testCase(UnweightedGraphTests.allTests),
    testCase(CycleTests.allTests),
    testCase(UniqueElementsGraphTests.allTests),
    testCase(UniqueElementsGraphInitTests.allTests),
    testCase(UnionTests.allTests),
    testCase(SwiftGraphCodableTests.allTests),
    testCase(ConstructorsTests.allTests),

    testCase(SearchPerformanceTests.allTests),
    testCase(ConstructorsPerformanceTests.allTests),
])
