//
//  AppDelegate.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2019 David Kopec
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

// NOTE: This sample app may run a bit slowly when compiled for DEBUG/without compiler optimizations turned on.
// For a better sense of how to use SwiftGraph see the unit tests.

import AppKit
import QuartzCore
import Cocoa
import SwiftGraph

class NineTailView: NSView {
    var position: NineTailPosition = NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]) {
        didSet {
            for i in 0..<position.positionMatrix.count {
                for j in 0..<position.positionMatrix[0].count  {
                    CATransaction.begin()
                    CATransaction.setValue(NSNumber(value: 2.5), forKey: kCATransactionAnimationDuration)
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
                pennyLayers[i][j].frame = CGRect(x: CGFloat(CGFloat(i) * (width/3)), y: CGFloat(CGFloat(j) * (height/3)), width: (width/3), height: (height/3))
                layer?.addSublayer(pennyLayers[i][j])
            }
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        
        let bPath:NSBezierPath = NSBezierPath()
        bPath.move(to: NSMakePoint(width/3, 0))
        bPath.line(to: NSMakePoint(width/3, height))
        bPath.move(to: NSMakePoint(width/3 * 2, 0))
        bPath.line(to: NSMakePoint(width/3 * 2, height))
        bPath.move(to: NSMakePoint(0, height/3))
        bPath.line(to: NSMakePoint(width, height/3))
        bPath.move(to: NSMakePoint(0, height/3 * 2))
        bPath.line(to: NSMakePoint(width, height/3 * 2))
        bPath.stroke()
        
    }
    
    override func mouseDown(with theEvent: NSEvent) {
        let width: CGFloat = self.bounds.size.width
        let height: CGFloat = self.bounds.size.height
        let mousePlace:NSPoint = self.convert(theEvent.locationInWindow, from: nil)
        let row: Int = Int(mousePlace.x / (width / 3))
        let col: Int = Int(mousePlace.y / (height / 3))
        position = position.flip(row, column: col)
    }
}

enum Coin: String, Codable {
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

struct NineTailPosition: Equatable, Codable  {
    fileprivate var positionMatrix: [[Coin]]
    init(matrix: [[Coin]]) {
        positionMatrix = matrix
    }
    
    mutating func flipHelper(_ row: Int, column: Int) {
        //ignore off board requests
        if (row >= 0 && row < positionMatrix.count && column >= 0 && column < positionMatrix[0].count) {
            positionMatrix[row][column].flip()
        }
    }
    func flip(_ row: Int, column: Int) -> NineTailPosition {
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
    var timer:Timer?
    
    func addPositionAndChildren(_ position: NineTailPosition, parent: Int) {
        let index: Int? = ntGraph.indexOfVertex(position)
        if let place = index {
            ntGraph.addEdge(fromIndex: parent, toIndex: place, directed: true)
        } else {
            let child: Int = ntGraph.addVertex(position)
            if (parent != -1) {
                ntGraph.addEdge(fromIndex: parent, toIndex: child, directed: true)
            }
            for i in 0..<3 {
                for j in 0..<3  {
                    let flipped = position.flip(i, column: j)
                    addPositionAndChildren(flipped, parent: child)
                    
                }
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.makeKeyAndOrderFront(self)
        ntView.needsDisplay = true  //redraw it if it wasn't automatically
        //add all the vertices
        addPositionAndChildren(NineTailPosition(matrix: [[.Heads, .Heads, .Heads],[.Heads, .Heads, .Heads], [.Heads, .Heads, .Heads]]), parent: -1)
    }
    
    @objc func timerFire(_ timer: Timer) {
        if !path.isEmpty {
            ntView.position = path.removeFirst()
        } else {
            timer.invalidate()
        }
    }
    
    @IBAction func solve(_ sender: AnyObject) {
        let temp = ntGraph.bfs(from: ntView.position, to: NineTailPosition(matrix: [[.Tails, .Tails, .Tails],[.Tails, .Tails, .Tails], [.Tails, .Tails, .Tails]]))
        path = ntGraph.edgesToVertices(edges: temp)
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(AppDelegate.timerFire(_:)), userInfo: nil, repeats: true)
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

