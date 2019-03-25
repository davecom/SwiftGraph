#!/bin/bash
swift test --generate-linuxmain
git diff --exit-code
