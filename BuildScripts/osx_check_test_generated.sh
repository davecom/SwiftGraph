#!/bin/bash
set -ev

# Assert that the linux test files are generated.
# We need to make this test here since the command only works on osx.
# swift test --generate-linuxmain
git diff --exit-code
