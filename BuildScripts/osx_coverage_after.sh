#!/bin/bash
set -ev
# Generate cobertura coverage info
slather coverage --input-format profdata -x --scheme SwiftGraph SwiftGraph.xcodeproj
# Send coverage info to codeclimate
./cc-test-reporter after-build --exit-code $TRAVIS_TEST_RESULT
