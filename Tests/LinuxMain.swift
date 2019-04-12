import XCTest

//import SwiftGraphPerformanceTests
import SwiftGraphTests

var tests = [XCTestCaseEntry]()
//tests += SwiftGraphPerformanceTests.__allTests()
tests += SwiftGraphTests.__allTests()

XCTMain(tests)
