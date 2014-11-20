//
//  AppDelegate.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        var g: WeightedGraph<String, Int> = WeightedGraph<String, Int>()
        g.addVertex("Atlanta")
        g.addVertex("New York")
        g.addVertex("Miami")
        g.addEdge("Atlanta", to: "New York", weight:2)
        g.addEdge("Miami", to: "Atlanta", weight: 4)
        g.addEdge("New York", to: "Miami", weight: 6)
        g.removeVertex("Atlanta")
        println(g)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

