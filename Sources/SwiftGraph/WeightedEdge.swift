//
//  WeightedEdge.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2017 David Kopec
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

/// A weighted edge, who's weight subscribes to Comparable.
open class WeightedEdge<W: Comparable & Numeric & Codable>: UnweightedEdge, Comparable {
    public let weight: W
    
    public init(u: Int, v: Int, weight: W) {
        self.weight = weight
        super.init(u: u, v: v)
    }
    
    enum CodingKeys: String, CodingKey {
        case weight
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.weight = try values.decode(W.self, forKey: CodingKeys.weight)
        try super.init(from: decoder)
    }
    
    open override func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        try rootContainer.encode(weight, forKey: CodingKeys.weight)
        try super.encode(to: encoder)
    }
    
    //Implement Printable protocol
    public override var description: String {
        return "\(u) \(weight)> \(v)"
    }
    
    //MARK: Operator Overloads
    static public func == <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.u == rhs.u && lhs.v == rhs.v && lhs.weight == rhs.weight
    }
    
    static public func < <W>(lhs: WeightedEdge<W>, rhs: WeightedEdge<W>) -> Bool {
        return lhs.weight < rhs.weight
    }
}
