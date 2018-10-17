#!/bin/bash
# Set pipefail to get status code of xcodebuild if it fails
set -v -o pipefail
# Test
xcodebuild -enableCodeCoverage YES -project SwiftGraph.xcodeproj -scheme SwiftGraph test | xcpretty
# xcodebuild -enableCodeCoverage NO -project SwiftGraph.xcodeproj -scheme SwiftGraphPerformanceTests test | xcpretty
