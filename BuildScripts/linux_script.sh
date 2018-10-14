#!/bin/bash
swift test -c debug --filter "SwiftGraphTests"
swift test -c release -Xswiftc -enable-testing --filter "SwiftGraphPerformanceTests"
