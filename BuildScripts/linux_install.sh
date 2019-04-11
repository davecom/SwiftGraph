#!/bin/bash
set -ev
SWIFT_URL=$1

wget ${SWIFT_URL} -O /tmp/swift.tar.gz
mkdir swift
tar -xvf /tmp/swift.tar.gz -C swift --strip-components=1
