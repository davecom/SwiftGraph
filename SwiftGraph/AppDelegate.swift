//
//  AppDelegate.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//

// NOTE: This sample app may run a bit slowly when compiled for DEBUG/without compiler optimizations turned on.
// For a better sense of how to use SwiftGraph see the unit tests.

import AppKit
import QuartzCore
import Cocoa

class NineTailView: NSView {
    var position: NineTailPosition = NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]) {
        didSet {
            for i in 0..<position.positionMatrix.count {
                for j in 0..<position.positionMatrix[0].count  {
                    CATransaction.begin()
                    CATransaction.setValue(NSNumber(float: 2.5), forKey: kCATransactionAnimationDuration)
                    pennyLayers[i][j].contents = NSImage(named: position.positionMatrix[i][j].rawValue)!
                    CATransaction.commit()
                }
            }
            
        }
    }
    var pennyLayers:[[CALayer]] = [[CALayer]]()
    override func awakeFromNib() {
        wantsLayer = true
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        for i in 0..<position.positionMatrix.count {
            pennyLayers.append([CALayer]())
            for _ in 0..<position.positionMatrix[0].count {
                pennyLayers[i].append(CALayer())
            }
        }
        for i in 0..<position.positionMatrix.count {
            for j in 0..<position.positionMatrix[0].count {
                pennyLayers[i][j].contents = NSImage(named: "heads")
                pennyLayers[i][j].frame = CGRectMake(CGFloat(CGFloat(i) * (width/3)), CGFloat(CGFloat(j) * (height/3)), (width/3), (height/3))
                layer?.addSublayer(pennyLayers[i][j])
            }
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        
        let bPath:NSBezierPath = NSBezierPath()
        bPath.moveToPoint(NSMakePoint(width/3, 0))
        bPath.lineToPoint(NSMakePoint(width/3, height))
        bPath.moveToPoint(NSMakePoint(width/3 * 2, 0))
        bPath.lineToPoint(NSMakePoint(width/3 * 2, height))
        bPath.moveToPoint(NSMakePoint(0, height/3))
        bPath.lineToPoint(NSMakePoint(width, height/3))
        bPath.moveToPoint(NSMakePoint(0, height/3 * 2))
        bPath.lineToPoint(NSMakePoint(width, height/3 * 2))
        bPath.stroke()
        
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        let mousePlace:NSPoint = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        let row: Int = Int(mousePlace.x / (width / 3))
        let col: Int = Int(mousePlace.y / (height / 3))
        position = position.flip(row, column: col)
    }
}

enum Coin: String {
    case Heads = "heads"
    case Tails = "tails"
    mutating func flip() {
        if self == .Heads {
            self = .Tails
        } else {
            self = .Heads
        }
    }
}

struct NineTailPosition: Equatable  {
    private var positionMatrix: [[Coin]]
    init(matrix: [[Coin]]) {
        positionMatrix = matrix
    }
    
    mutating func flipHelper(row: Int, column: Int) {
        //ignore off board requests
        if (row >= 0 && row < positionMatrix.count && column >= 0 && column < positionMatrix[0].count) {
            positionMatrix[row][column].flip()
        }
    }
    func flip(row: Int, column: Int) -> NineTailPosition {
        var newPosition = NineTailPosition(matrix: positionMatrix)
        newPosition.flipHelper(row, column: column)
        newPosition.flipHelper(row - 1, column: column)
        newPosition.flipHelper(row + 1, column: column)
        newPosition.flipHelper(row, column: column + 1)
        newPosition.flipHelper(row, column: column - 1)
        return newPosition
    }
}

func ==(lhs: NineTailPosition, rhs: NineTailPosition) -> Bool {
    for i in 0..<3 {
        for j in 0..<3 {
            if lhs.positionMatrix[i][j] != rhs.positionMatrix[i][j] {
                return false
            }
        }
    }
    return true
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var ntView: NineTailView!
    let ntGraph: UnweightedGraph<NineTailPosition> = UnweightedGraph<NineTailPosition>()
    var path: [NineTailPosition] = [NineTailPosition]()
    var timer:NSTimer?
    
    func addPositionAndChildren(position: NineTailPosition, parent: Int) {
        let index: Int? = ntGraph.indexOfVertex(position)
        if let place = index {
            ntGraph.addEdge(parent, to: place, directed: true)
        } else {
            let child: Int = ntGraph.addVertex(position)
            if (parent != -1) {
                ntGraph.addEdge(parent, to: child, directed: true)
            }
            for i in 0..<3 {
                for j in 0..<3  {
                    let flipped = position.flip(i, column: j)
                    addPositionAndChildren(flipped, parent: child)
                    
                }
            }
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        window.makeKeyAndOrderFront(self)
        ntView.needsDisplay = true  //redraw it if it wasn't automatically
        //add all the vertices
        addPositionAndChildren(NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]), parent: -1)
    }
    
    func timerFire(timer: NSTimer) {
        if !path.isEmpty {
            ntView.position = path.removeAtIndex(0)
        } else {
            timer.invalidate()
        }
    }
    
    @IBAction func solve(sender: AnyObject) {
        let temp = bfs(ntView.position, to: NineTailPosition(matrix: [[.Tails, .Tails, .Tails],[.Tails, .Tails, .Tails], [.Tails, .Tails, .Tails]]), graph: ntGraph)
        path = edgesToVertices(temp, graph: ntGraph)
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: #selector(AppDelegate.timerFire(_:)), userInfo: nil, repeats: true)
    }
    

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

