#!/usr/bin/env bash

VERSION=$(git describe --tags --abbrev=0)

jazzy \
  --clean \
  --author David Kopec \
  --author_url https://twitter.com/davekopec \
  --github_url https://github.com/davecom/SwiftGraph \
  --github-file-prefix "https://github.com/davecom/SwiftGraph/tree/$VERSION" \
  --module-version "$VERSION" \
  --module SwiftGraph

