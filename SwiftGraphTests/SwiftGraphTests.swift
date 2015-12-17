//
//  SwiftGraphTests.swift
//  SwiftGraphTests
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

import XCTest
import GraphiOS

class SwiftGraphTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCitesInverseAfterRemove() {
        // This is an example of a functional test case.
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        g.addVertex("Atlanta")
        g.addVertex("New York")
        g.addVertex("Miami")
        g.addEdge("Atlanta", to: "New York")
        g.addEdge("Miami", to: "Atlanta")
        g.addEdge("New York", to: "Miami")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.neighborsForVertex("Miami")!, g.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miam and New York Connected bi-directionally")
    }
    
    func testSequenceTypeAndCollectionType() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        g.addVertex("Atlanta")
        g.addVertex("New York")
        g.addVertex("Miami")
        var tempList: [String] = []
        for v in g {
            tempList.append(v)
        }
        XCTAssertEqual(tempList, ["Atlanta", "New York", "Miami"], "Iterated Successfully")
        XCTAssertEqual(g[1], "New York", "Subscripted Successfully")
    }
    
    //func testPerformanceExample() {
        // This is an example of a performance test case.
     //   self.measureBlock() {
            // Put the code you want to measure the time of here.
     //   }
    //}
    
}
