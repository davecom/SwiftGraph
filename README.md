# SwiftGraph

[![Swift Versions](https://img.shields.io/badge/Swift-1%2C2%2C3%2C4-green.svg)](https://swift.org)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/SwiftGraph.svg)](https://cocoapods.org/pods/SwiftGraph)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/SwiftGraph.svg)](https://cocoapods.org/pods/SwiftGraph)
[![Linux Compatible](https://img.shields.io/badge/Linux-compatible-4BC51D.svg?style=flat)](https://swift.org)
[![Twitter Contact](https://img.shields.io/badge/contact-@davekopec-blue.svg?style=flat)](https://twitter.com/davekopec)

SwiftGraph is a pure Swift (no Cocoa) implementation of a graph data structure, appropriate for use on all platforms Swift supports (iOS, macOS, Linux, etc.). It includes support for weighted, unweighted, directed, and undirected graphs. It uses generics to abstract away both the type of the nodes, and the type of the weights.

It includes copious in-source documentation, unit tests, as well as search functions for doing things like breadth-first search, depth-first search, and Dijkstra's algorithm. Further, it includes utility functions for topological sort, Jarnik's algorithm to find a minimum-spanning tree, detecting a DAG (directed-acyclic-graph), and enumerating all cycles.

- [Installation](#installation)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager (SPM)](#swift-package-manager-spm)
    - [Manual](#manual)
- [Tips and Tricks](#tips-and-tricks)
- [Example](#example)
- [Documentation](#documentation)
    - [Edges](#edges)
    - [Graphs](#graphs)
    - [Search](#search)
    - [Sort & Miscellaneous](#sort-miscellaneous)
- [Authorship & License](#authorship-license)
- [Future Direction](#future-direction)

## Installation

SwiftGraph 1.5.0 and above requires Swift 4. Use SwiftGraph 1.4.1 for Swift 3 (Xcode 8), SwiftGraph 1.0.6 for Swift 2 (Xcode 7), and SwiftGraph 1.0.0 for Swift 1.2 (Xcode 6.3) support.

### CocoaPods

Use the CocoaPod `SwiftGraph`.

### Carthage

Add the following to your `Cartfile`:

```
github "davecom/SwiftGraph" ~> 1.5.1
```

### Swift Package Manager (SPM)

Use this repository as your dependency.

### Manual

Copy all of the sources in the `Sources` folder into your project.

## Tips and Tricks

* To get a sense of how to use SwiftGraph, checkout the unit tests
* Inserting an edge by node indices is much faster than inserting an edge by node objects that need to have their indices looked up
* Generally, looking for the index of a node is O(n) time, with n being the number of nodes in the graph
* SwiftGraph includes the functions `bfs()` and `dfs()` for finding a route between one node and another in a graph and `dijkstra()` for finding shortest paths in a weighted graph
* A sample Mac app that implements the Nine Tails problem is included - just change the target of the project to `SwiftGraphSampleApp` to build it

## Example

For more detail, checkout the _Documentation_ section, but this example building up a weighted graph of American cities and doing some operations on it, should get you started.

```swift
let cityGraph: WeightedGraph<String, Int> = WeightedGraph<String, Int>(nodes: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
```

`cityGraph` is a `WeightedGraph` with `String` nodes and `Int` weights on its edges.

```swift
cityGraph.addEdge(from: "Seattle", to:"Chicago", weight:2097)
cityGraph.addEdge(from: "Seattle", to:"Chicago", weight:2097)
cityGraph.addEdge(from: "Seattle", to: "Denver", weight:1331)
cityGraph.addEdge(from: "Seattle", to: "San Francisco", weight:807)
cityGraph.addEdge(from: "San Francisco", to: "Denver", weight:1267)
cityGraph.addEdge(from: "San Francisco", to: "Los Angeles", weight:381)
cityGraph.addEdge(from: "Los Angeles", to: "Denver", weight:1015)
cityGraph.addEdge(from: "Los Angeles", to: "Kansas City", weight:1663)
cityGraph.addEdge(from: "Los Angeles", to: "Dallas", weight:1435)
cityGraph.addEdge(from: "Denver", to: "Chicago", weight:1003)
cityGraph.addEdge(from: "Denver", to: "Kansas City", weight:599)
cityGraph.addEdge(from: "Kansas City", to: "Chicago", weight:533)
cityGraph.addEdge(from: "Kansas City", to: "New York", weight:1260)
cityGraph.addEdge(from: "Kansas City", to: "Atlanta", weight:864)
cityGraph.addEdge(from: "Kansas City", to: "Dallas", weight:496)
cityGraph.addEdge(from: "Chicago", to: "Boston", weight:983)
cityGraph.addEdge(from: "Chicago", to: "New York", weight:787)
cityGraph.addEdge(from: "Boston", to: "New York", weight:214)
cityGraph.addEdge(from: "Atlanta", to: "New York", weight:888)
cityGraph.addEdge(from: "Atlanta", to: "Dallas", weight:781)
cityGraph.addEdge(from: "Atlanta", to: "Houston", weight:810)
cityGraph.addEdge(from: "Atlanta", to: "Miami", weight:661)
cityGraph.addEdge(from: "Houston", to: "Miami", weight:1187)
cityGraph.addEdge(from: "Houston", to: "Dallas", weight:239)
```

Convenience methods are used to add `WeightedEdge` connections between various nodes.

```swift
let (distances, pathDict) = cityGraph.dijkstra(root: "New York", startDistance: 0)
var nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
// shortest distance from New York to San Francisco
let temp = nameDistance["San Francisco"]
// path between New York and San Francisco
let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex("New York")!, to: cityGraph.indexOfVertex("San Francisco")!, pathDict: pathDict)
let stops: [String] = edgesToVertices(edges: path, graph: cityGraph)
```

The shortest paths are found between various nodes in the graph using Dijkstra's algorithm.

```swift
let mst = cityGraph.mst()
```

The minimum spanning tree is found connecting all of the nodes in the graph.

```swift
let cycles = cityGraph.detectCycles()
```

All of the cycles in `cityGraph` are found.

```swift
let isADAG = cityGraph.isDAG
```

`isADAG` is `false` because `cityGraph` is not found to be a Directed Acyclic Graph.

```swift
let result = cityGraph.findAll(from: "New York") { v in
    return v.characters.first == "S"
}
```

A breadth-first search is performed, starting from New York, for all cities in `cityGraph` that start with the letter "S."

SwiftGraph contains many more useful features, but hopefully this example was a nice quickstart.

## Documentation

There is a large amount of documentation in the source code using the latest Apple documentation technique - so you should be able to just alt-click a method name to get a lot of great information about it in Xcode. There are up-to-date HTML docs available online thanks to the good folks at [CocoaPods](http://cocoadocs.org/docsets/SwiftGraph/) In addition, here's some more basic information:

### Edges

Edges connect the nodes in your graph to one another.

* `Edge` (Protocol) - A protocol that all edges in a graph must conform to. An edge is a connection between two nodes in the graph. The nodes are specified by their index in the graph which is an integer. Further, an edge knows if it's directed, or weighted. An edge can create a reversed version of itself.
* `UnweightedEdge` - This is a concrete implementation of `Edge` for unweighted graphs.
* `WeightedEdge` - A subclass of `UnweightedEdge` that adds weights. Weights are a generic type - they can be anything that implements `Comparable` and `Summable`. `Summable` is anything that implements the `+` operator. To add `Summable` support to a data type that already has the plus operator, simply write something like (support in SwiftGraph is already included for `Int`, `Float`, `Double`, and `String`):

```swift
extension Int: Summable {}
```

### Graphs

Graphs are the data structures at the heart of SwiftGraph. All nodes are assigned an integer index when they are inserted into a graph and it's generally faster to refer to them by their index than by the node's actual object.

Graphs implement the standard Swift protocols `SequenceType` (for iterating through all nodes) and `CollectionType` (for grabbing a node by its index through a subscript). For instance, the following example prints all nodes in a Graph on separate lines:

```swift
for v in g {  // g is a Graph<String>
    print(v)
}
```

And we can grab a specific node by its index using a subscript

```swift
print(g[23]) // g is a Graph<String>
```

Note: At this time, graphs are _not_ thread-safe. However, once a graph is constructed, if you will only be doing lookups and searches through it (no removals of nodes/edges and no additions of nodes/edges) then you should be able to do that from multiple threads. A fully thread-safe graph implementation is a possible future direction.

* `Graph` - This is the base class for all graphs. Generally, you should use one of its canonical subclasses, `UnweightedGraph` or `WeightedGraph`, because they offer more functionality. The nodes in a `Graph` (defined as a generic at graph creation time) can be of any type that conforms to `Equatable`. `Graph` has methods for:
  * Adding a node
  * Getting the index of a node
  * Finding the neighbors of an index/node
  * Finding the edges of an index/node
  * Checking if an edge from one index/node to another index/node exists
  * Checking if a node is in the graph
  * Adding an edge
  * Removing all edges between two indexes/nodes
  * Removing a particular node (all other edge relationships are automatically updated at the same time (because the indices of their connections changes) so this is slow - O(v + e) where v is the number of nodes and e is the number of edges)
* `UnweightedGraph` - A subclass of `Graph` that adds convenience methods for adding and removing edges of type `UnweightedEdge`.
* `WeightedGraph` - A subclass of `Graph` that adds convenience methods for adding and removing edges of type `WeightedEdge`. `WeightedGraph` also adds a method for returning a list of tuples containing all of the neighbor nodes of an index along with their respective weights.

### Search

Search methods are defined in extensions of `Graph` and `WeightedGraph` in `Search.swift`.

* `bfs()` (method on `Graph`) - Finds a path from one node to another in a `Graph` using a breadth-first search. Returns an array of `Edge`s going from the source node to the destination node or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a node and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first node that returns true from `goalTest()`.
* `dfs()` (method on `Graph`) - Finds a path from one node to another in a `Graph` using a depth-first search. Returns an array of `Edge`s going from the source node to the destination node or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a node and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first node that returns true from `goalTest()`.
* `findAll()` Uses a breadth-first search to find all connected nodes from the starting node that return true when run through a `goalTest()` function. Paths to the connected nodes are returned in an array, which is empty if no nodes are found.
* `dijkstra()` (method on `WeightedGraph`) - Finds the shortest path from a starting node to every other node in a `WeightedGraph`. Returns a tuple who's first element is an array of the distances to each node in the graph arranged by index. The second element of the tuple is a dictionary mapping graph indices to the previous `Edge` that gets them there in the shortest time from the staring node. Using this dictionary and the function `pathDictToPath()`, you can find the shortest path from the starting node to any other connected node. See the `dijkstra()` unit tests in `DijkstraGraphTests.swift` for a demo of this.

### Sort & Miscellaneous

An extension to `Graph` in `Sort.swift` provides facilities for topological sort and detecting a DAG.

* `topologicalSort()` - Does a topological sort of the nodes in a given graph if possible (returns nil if it finds a cycle). Returns a sorted list of the nodes. Runs in O(n) time.
* `isDAG` - A property that uses `topologicalSort()` to determine whether a graph is a DAG (directed-acyclic graph). Runs in O(n) time.

An extension to `WeightedGraph` in `MST.swift` can find a minimum-spanning tree from a weighted graph.

* `mst()` - Uses Jarnik's Algorithm (aka Prim's Algorithm) to find the tree made of minimum cumulative weight that connects all nodes in a weighted graph. This assumes the graph is completely undirected and connected. If the graph has directed edges, it may not return the right answer. Also, if the graph is not fully connected it will create the tree for the connected component that the starting node is a part of. Returns an array of `WeightedEdge`s that compose the tree. Use utility functions `totalWeight()` and `printMST()` to examine the returned MST. Runs in O(n lg n) time.

An extension to `Graph` in `Cycles.swift` finds all of the cycles in a graph.

* `detectCycles()` - Uses an algorithm developed by Liu/Wang to find all of the cycles in a graph. Optionally, this method can take one parameter, `upToLength`, that specifies a length at which to stop searching for cycles. For instance, if `upToLength` is 3, `detectCycles()` will find all of the 1 node cycles (self-cycles, nodes with edges to themselves), and 3 node cycles (connection to another node and back again, present in all undirected graphs with more than 1 node). There is no such thing as a 2 node cycle.

## Authorship & License

SwiftGraph is written by David Kopec and released under the Apache License (see `LICENSE`). You can find my email address on my GitHub profile page. I encourage you to submit pull requests and open issues here on GitHub.

## Future Direction

Future directions for this project to take could include:

* More utility functions
* A thread safe subclass of `Graph`
* More extensive performance testing
