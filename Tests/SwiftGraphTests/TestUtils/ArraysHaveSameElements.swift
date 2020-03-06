//
//  ArrayHaveSameElements.swift
//  SwiftGraph
//
//  Copyright (c) 2019 Ferran Pujol Camins
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

// Returns true if both arrays have the same elements with the same number, regardless of the order.
func arraysHaveSameElements<T: Equatable>(_ a1: [T], _ a2: [T]) -> Bool {
    guard a1.count == a2.count else {
        return false
    }

    for e in a1 {
        if !a2.contains(e) {
            return false
        }
    }
    return true
}
