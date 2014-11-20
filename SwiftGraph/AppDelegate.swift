//
//  AppDelegate.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//
import AppKit
import Cocoa

class NineTailView: NSView {
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        
        var bPath:NSBezierPath = NSBezierPath()
        bPath.moveToPoint(NSMakePoint(width/3, 0))
        bPath.lineToPoint(NSMakePoint(width/3, height))
        bPath.stroke()
    }
}

enum Coin: Equatable {
    case Heads, Tails
    mutating func flip() {
        if self == .Heads {
            self = .Tails
        } else {
            self = .Heads
        }
    }
}

struct NineTailPosition: Equatable  {
    var position: [[Coin]]
    subscript(row: Int, column: Int) -> Coin {
        return position[row][column]
    }
    
}

func ==(lhs: NineTailPosition, rhs: NineTailPosition) -> Bool {
    for var i = 0; i < 3; i++ {
        for var j = 0; j < 3; j++ {
            if lhs[i, j] != rhs[i, j] {
                return false
            }
        }
    }
    return true
}

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

