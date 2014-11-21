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
                    
                    /*var changeImageAnimation: CABasicAnimation = CABasicAnimation(keyPath: "contents")
                    changeImageAnimation.fromValue = pennyLayers[i][j].contents
                    let newImage: NSImage = NSImage(named: position.positionMatrix[i][j].rawValue)!
                    changeImageAnimation.toValue = newImage
                    changeImageAnimation.duration = 3.0
                    pennyLayers[i][j].addAnimation(changeImageAnimation, forKey: "contents")*/
                    
                    CATransaction.begin()
                    CATransaction.setValue(NSNumber(float: 2.5), forKey: kCATransactionAnimationDuration)
                    pennyLayers[i][j].contents = NSImage(named: position.positionMatrix[i][j].rawValue)!
                    CATransaction.commit()
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
    let ntGraph: UnweightedGraph<NineTailPosition> = UnweightedGraph<NineTailPosition>()
    var path: [NineTailPosition] = [NineTailPosition]()
    var timer:NSTimer?

    // based on Introduction to Java Programming by Liang p 1052 Java function getNode()
    /*func positionForIndex(inout index: Int) -> NineTailPosition {
        var matrix:[[Coin]] = [[Coin]]()
        //initialize matrix
        for var i = 0; i < 3; i++ {
            matrix[i] = [Coin]()
            for var j = 0; j < 3; j++ {
                matrix[i].append(.Heads)
            }
        }
        
        //Again this is an algorithm from Liang Introduction to Java Programming p 1052
        for var i = 0; i < 9; i++ {
            let digit: Int = index % 2
            if digit != 0 {
                matrix[8-i] = .Tails
            }
            index = index / 2
        }
    }*/
    
    func addPositionAndChildren(position: NineTailPosition) {
        if !ntGraph.vertexInGraph(position) {
            ntGraph.addVertex(position)
            
            for var i = 0; i < 3; i++ {
                for var j = 0; j < 3; j++ {
                    let flipped = position.flip(i, column: j)
                    addPositionAndChildren(flipped)
                    ntGraph.addEdge(position, to: flipped, directed: true)
                }
            }
        }
    }
    
    func addPositionAndChildren2(position: NineTailPosition) {
        var verticesToAdd: [NineTailPosition] = [NineTailPosition]()
        //var edgesToAdd: [UnweightedEdge] = [UnweightedEdge]()
        var last: NineTailPosition? = nil
        ntGraph.addVertex(position)
        verticesToAdd.append(position)
        while (!verticesToAdd.isEmpty) {
            let position:NineTailPosition = verticesToAdd.removeLast()
            let parentIndex:Int = ntGraph.indexOfVertex(position)!
            for var i = 0; i < 3; i++ {
                for var j = 0; j < 3; j++ {
                    let flipped = position.flip(i, column: j)
                    if !ntGraph.vertexInGraph(flipped) {
                        verticesToAdd.append(flipped)
                        ntGraph.addVertex(flipped)
                        ntGraph.addEdge(parentIndex, to: ntGraph.vertexCount - 1, directed: true)
                        //edgesToAdd.append(UnweightedEdge(u: p, v: flipped, directed: true))
                    }
                }
            }
        }
        /*for e: UnweightedEdge in edgesToAdd {
            ntGraph.addEdge(e)
        }*/
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        ntView.needsDisplay = true  //redraw it if it wasn't automatically
        //ntView.position = NineTailPosition(matrix: [[.Heads, .Heads, .Tails],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]])
        //add all the vertices
        addPositionAndChildren(NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]))
        println(ntGraph)
        

    }
    
    func timerFire(timer: NSTimer) {
        if !path.isEmpty {
            //println("Changing position")
            ntView.position = path.removeAtIndex(0)
        } else {
            timer.invalidate()
        }
    }
    
    @IBAction func solve(sender: AnyObject) {
        var temp = bfs(ntView.position, NineTailPosition(matrix: [[.Tails, .Tails, .Tails],[.Tails, .Tails, .Tails], [.Tails, .Tails, .Tails]]), ntGraph)
        path = edgesToVertices(temp, ntGraph)
        //print(path)
        timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "timerFire:", userInfo: nil, repeats: true)
    }
    

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

