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
        var g: UnweightedGraph<String> = UnweightedGraph<String>()
        g.addVertex("Atlanta")
        g.addVertex("New York")
        g.addVertex("Miami")
        g.addEdge("Atlanta", to: "New York")
        g.addEdge("Miami", to: "Atlanta")
        g.addEdge("New York", to: "Miami")
        g.removeVertex("Atlanta")
        println(g)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

