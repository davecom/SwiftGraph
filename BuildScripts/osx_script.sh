#!/bin/bash
# Set pipefail to get status code of xcodebuild if it fails
set -v -o pipefail
# Test
xcodebuild -enableCodeCoverage YES -project SwiftGraph.xcodeproj -scheme SwiftGraph test | xcpretty
