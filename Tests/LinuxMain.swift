@testable import SwiftGraphTests
import XCTest

XCTMain([
    testCase(DijkstraGraphTests.allTests),
    testCase(MSTTests.allTests),
    testCase(SwiftGraphSearchTests.allTests),
    testCase(SwiftGraphSortTests.allTests),
    testCase(SwiftGraphTests.allTests),
    testCase(CycleTests.allTests),
])
