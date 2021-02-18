//
//  SwiftGraphReversedTests.swift
//  SwiftGraph
//
//  Created by Matthew Paletta on 2021-02-18.
//  Copyright © 2021 Oak Snow Consulting. All rights reserved.
//

import XCTest
@testable import SwiftGraph

class SwiftGraphReversedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCitesReversedDirected() {
        let g = UnweightedGraph<String>(vertices: ["Atlanta", "New York", "Miami"])
        g.addEdge(from: "Atlanta", to: "New York", directed: true)
        g.addEdge(from: "Miami", to: "Atlanta", directed: true)
        g.addEdge(from: "New York", to: "Miami", directed: true)
        
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(g.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(g.edgeExists(from: "New York", to: "Miami"))
        
        let r: UnweightedGraph<String> = g.reversed()
        XCTAssertFalse(r.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertFalse(r.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertFalse(r.edgeExists(from: "New York", to: "Miami"))
        
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "Miami"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "New York"))
    }

    func testCitesReversedUndirected() {
        let g = UnweightedGraph<String>(vertices: ["Atlanta", "New York", "Miami"])
        g.addEdge(from: "Atlanta", to: "New York", directed: false)
        g.addEdge(from: "Miami", to: "Atlanta", directed: false)
        g.addEdge(from: "New York", to: "Miami", directed: false)
        
        XCTAssertTrue(g.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(g.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(g.edgeExists(from: "New York", to: "Miami"))
        
        let r: UnweightedGraph<String> = g.reversed()
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "New York"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Miami"))
        
        XCTAssertTrue(r.edgeExists(from: "New York", to: "Atlanta"))
        XCTAssertTrue(r.edgeExists(from: "Atlanta", to: "Miami"))
        XCTAssertTrue(r.edgeExists(from: "Miami", to: "New York"))
    }
}
