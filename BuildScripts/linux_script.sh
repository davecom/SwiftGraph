#!/bin/bash
set -ev
swift test -c debug --filter "SwiftGraphTests"
# swift test -c release -Xswiftc -enable-testing --filter "SwiftGraphPerformanceTests"
