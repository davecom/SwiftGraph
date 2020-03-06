//
//  UtilsTests.swift
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

import XCTest
@testable import SwiftGraph
import SwiftCheck

struct ArbitraryArrayWithDuplicates<Element: Arbitrary>: Arbitrary {
    let array: [Element]

    static var arbitrary: Gen<ArbitraryArrayWithDuplicates> {
        // We construct an array and then we add a random number of its elements to itself
        // to ensure there are duplicates.
        [Element].arbitrary
            .suchThat { $0.count > 0 }
            .flatMap { array in
                UInt.arbitrary
                    .suchThat { $0 > 0 }
                    .map { (0..<$0).compactMap { _ in array.randomElement() } }
                    .map { (array + $0).shuffled() }
            }
            .map { ArbitraryArrayWithDuplicates(array: $0) }
    }

    static func shrink(_ a: Self) -> [Self] {
        [Element].shrink(a.array).map(ArbitraryArrayWithDuplicates.init)
    }
}

struct ArbitraryArrayWithNoDuplicates<Element: Arbitrary & IntInitializable>: Arbitrary {
    let array: [Element]

    static var arbitrary: Gen<ArbitraryArrayWithNoDuplicates> {
        Gen.sized { size in
            Gen.pure((0..<size).shuffled())
        }
        .map { ArbitraryArrayWithNoDuplicates(array: $0.map(Element.init)) }
    }

    static func shrink(_ a: Self) -> [Self] {
        [Element].shrink(a.array).map(ArbitraryArrayWithNoDuplicates.init)
    }
}

protocol IntInitializable {
    init(_ i: Int)
}

extension Int: IntInitializable {}

struct NonHashableInt: Equatable, Codable, Arbitrary, IntInitializable {
    let value: Int

    init(_ i: Int) {
        value = i
    }

    static var arbitrary: Gen<NonHashableInt> {
        Gen.compose { NonHashableInt($0.generate()) }
    }

    static func shrink(_ a: Self) -> [Self] {
        Int.shrink(a.value).map(NonHashableInt.init)
    }
}

class UtilsTests: XCTestCase {
    func testAllDistinct() {
        property("Collections with no duplicates return true") <- forAll { (a: ArbitraryArrayWithNoDuplicates<NonHashableInt>) in
            a.array.allDistinct() == true
        }
        property("Collections with duplicates return false") <- forAll { (a: ArbitraryArrayWithDuplicates<NonHashableInt>) in
            a.array.allDistinct() == false
        }
    }

    func testHashableAllDistinct() {
        property("Collections with no duplicates return true") <- forAll { (a: ArbitraryArrayWithNoDuplicates<Int>) in
            a.array.allDistinct() == true
        }
        property("Collections with duplicates return false") <- forAll { (a: ArbitraryArrayWithDuplicates<Int>) in
            a.array.allDistinct() == false
        }
    }
}
