//
//  Utils.swift
//  SwiftGraph
//
//  Copyright (c) 2020 Ferran Pujol Camins
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

extension Collection where Element: Equatable {
    func allDistinct() -> Bool {
        for i in indices {
            let n = index(after: i)
            for e in self[n...] {
                if self[i] == e { return false }
            }
        }
        return true
    }
}

extension Collection where Element: Hashable {
    func allDistinct() -> Bool {
        Set(self).count == count
    }
}
