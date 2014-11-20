//
//  AppDelegate.swift
//  SwiftGraph
//
//  Created by David Kopec on 11/16/14.
//  Copyright (c) 2014 Oak Snow Consulting. All rights reserved.
//
import AppKit
import QuartzCore
import Cocoa

class NineTailView: NSView {
    var position: NineTailPosition = NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]) {
        didSet {
            //position = newValue
            for var i = 0; i < position.positionMatrix.count; i++ {
                for var j = 0; j < position.positionMatrix[0].count; j++ {
                    
                    var changeImageAnimation: CABasicAnimation = CABasicAnimation(keyPath: "contents")
                    changeImageAnimation.fromValue = pennyLayers[i][j].contents
                    let newImage: NSImage = NSImage(named: position.positionMatrix[i][j].rawValue)!
                    changeImageAnimation.toValue = newImage
                    changeImageAnimation.duration = 3.0
                    pennyLayers[i][j].addAnimation(changeImageAnimation, forKey: "contents")
                    //pennyLayers[i][j].contents = newImage
                }
            }
            
        }
    }
    var pennyLayers:[[CALayer]] = [[CALayer]]()
    override func awakeFromNib() {
        wantsLayer = true
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        for var i = 0; i < position.positionMatrix.count; i++ {
            pennyLayers.append([CALayer]())
            for var j = 0; j < position.positionMatrix[0].count; j++ {
                pennyLayers[i].append(CALayer())
            }
        }
        for var i = 0; i < position.positionMatrix.count; i++ {
            for var j = 0; j < position.positionMatrix[0].count; j++ {
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
        
        var bPath:NSBezierPath = NSBezierPath()
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
        newPosition.flipHelper(row + 1, column: column + 1)
        newPosition.flipHelper(row + 1, column: column - 1)
        return newPosition
    }
}

func ==(lhs: NineTailPosition, rhs: NineTailPosition) -> Bool {
    for var i = 0; i < 3; i++ {
        for var j = 0; j < 3; j++ {
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
    

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        /*var g: WeightedGraph<String, Int> = WeightedGraph<String, Int>()
        g.addVertex("Atlanta")
        g.addVertex("New York")
        g.addVertex("Miami")
        g.addEdge("Atlanta", to: "New York", weight:2)
        g.addEdge("Miami", to: "Atlanta", weight: 4)
        g.addEdge("New York", to: "Miami", weight: 6)
        g.removeVertex("Atlanta")
        println(g)*/
        
        ntView.needsDisplay = true  //redraw it if it wasn't automatically
        ntView.position = NineTailPosition(matrix: [[.Heads, .Heads, .Tails],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]])
    }
    
    @IBAction func solve(sender: AnyObject) {
    }
    

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

