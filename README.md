# SwiftGraph

[![Swift Versions](https://img.shields.io/badge/Swift-1%2C2%2C3%2C4%2C5-green.svg)](https://swift.org)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/SwiftGraph.svg)](https://cocoapods.org/pods/SwiftGraph)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods Platforms](https://img.shields.io/cocoapods/p/SwiftGraph.svg)](https://cocoapods.org/pods/SwiftGraph)
[![Linux Compatible](https://img.shields.io/badge/Linux-compatible-4BC51D.svg?style=flat)](https://swift.org)
[![Twitter Contact](https://img.shields.io/badge/contact-@davekopec-blue.svg?style=flat)](https://twitter.com/davekopec)
[![Build Status](https://travis-ci.org/davecom/SwiftGraph.svg?branch=master)](https://travis-ci.org/davecom/SwiftGraph)
[![Maintainability](https://api.codeclimate.com/v1/badges/b93b35351ff96b21678f/maintainability)](https://codeclimate.com/github/davecom/SwiftGraph/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b93b35351ff96b21678f/test_coverage)](https://codeclimate.com/github/davecom/SwiftGraph/test_coverage)

SwiftGraph is a pure Swift (no Cocoa) implementation of a graph data structure, appropriate for use on all platforms Swift supports (iOS, macOS, Linux, etc.). It includes support for weighted, unweighted, directed, and undirected graphs. It uses generics to abstract away both the type of the vertices, and the type of the weights.

It includes copious in-source documentation, unit tests, as well as search functions for doing things like breadth-first search, depth-first search, and Dijkstra's algorithm. Further, it includes utility functions for topological sort, Jarnik's algorithm to find a minimum-spanning tree, detecting a DAG (directed-acyclic-graph), enumerating all cycles, and more.

## Installation

SwiftGraph 3.0 and above requires Swift 5 (Xcode 10.2). Use SwiftGraph 2.0 for Swift 4.2 (Xcode 10.1) support, SwiftGraph 1.5.1 for Swift 4.1 (Xcode 9), SwiftGraph 1.4.1 for Swift 3 (Xcode 8), SwiftGraph 1.0.6 for Swift 2 (Xcode 7), and SwiftGraph 1.0.0 for Swift 1.2 (Xcode 6.3) support. SwiftGraph supports GNU/Linux and is tested on it.

### CocoaPods

Use the CocoaPod `SwiftGraph`.

### Carthage

Add the following to your `Cartfile`:

```
github "davecom/SwiftGraph" ~> 3.1
```

### Swift Package Manager (SPM)

Use this repository as your dependency.

### Manual

Copy all of the sources in the `Sources` folder into your project.

## Tips and Tricks
* To get a sense of how to use SwiftGraph, checkout the unit tests
* Inserting an edge by vertex indices is much faster than inserting an edge by vertex objects that need to have their indices looked up
* Generally, looking for the index of a vertex is O(n) time, with n being the number of vertices in the graph
* SwiftGraph includes the functions `bfs()` and `dfs()` for finding a route between one vertex and another in a graph and `dijkstra()` for finding shortest paths in a weighted graph
* A sample Mac app that implements the Nine Tails problem is included - just change the target of the project to `SwiftGraphSampleApp` to build it

## Example

For more detail, checkout the *Documentation* section, but this example building up a weighted graph of American cities and doing some operations on it, should get you started.

```swift
let cityGraph: WeightedGraph<String, Int> = WeightedGraph<String, Int>(vertices: ["Seattle", "San Francisco", "Los Angeles", "Denver", "Kansas City", "Chicago", "Boston", "New York", "Atlanta", "Miami", "Dallas", "Houston"])
```
`cityGraph` is a `WeightedGraph` with `String` vertices and `Int` weights on its edges.
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
Convenience methods are used to add `WeightedEdge` connections between various vertices.
```swift
let (distances, pathDict) = cityGraph.dijkstra(root: "New York", startDistance: 0)
var nameDistance: [String: Int?] = distanceArrayToVertexDict(distances: distances, graph: cityGraph)
// shortest distance from New York to San Francisco
let temp = nameDistance["San Francisco"] 
// path between New York and San Francisco
let path: [WeightedEdge<Int>] = pathDictToPath(from: cityGraph.indexOfVertex("New York")!, to: cityGraph.indexOfVertex("San Francisco")!, pathDict: pathDict)
let stops: [String] = cityGraph.edgesToVertices(edges: path)
```
The shortest paths are found between various vertices in the graph using Dijkstra's algorithm.
```swift
let mst = cityGraph.mst()
```
The minimum spanning tree is found connecting all of the vertices in the graph.
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
There is a large amount of documentation in the source code using the latest Apple documentation technique—so you should be able to just alt-click a method name to get a lot of great information about it in Xcode. We also use Jazzy to produce [HTML Docs](https://davecom.github.io/SwiftGraph). In addition, here's an overview of each of SwiftGraph's components:

### Edges
Edges connect the vertices in your graph to one another.

* `Edge` (Protocol) - A protocol that all edges in a graph must conform to. An edge is a connection between two vertices in the graph. The vertices are specified by their index in the graph which is an integer. All `Edge`s must be `Codable`.
* `UnweightedEdge` - This is a concrete implementation of `Edge` for unweighted graphs.
* `WeightedEdge` - This is a concrete implementation of `Edge` for weighted graphs. Weights are a generic type - they can be anything that implements `Comparable`, `Numeric` and `Codable`.  Typical weight types are `Int` and `Float`.

### Graphs
Graphs are the data structures at the heart of SwiftGraph. All vertices are assigned an integer index when they are inserted into a graph and it's generally faster to refer to them by their index than by the vertex's actual object.

Graphs implement the standard Swift protocols `Collection` (for iterating through all vertices and for grabbing a vertex by its index through a subscript) and `Codable` . For instance, the following example prints all vertices in a Graph on separate lines:
```swift
for v in g {  // g is a Graph<String>
    print(v)
}
```
And we can grab a specific vertex by its index using a subscript
```swift
print(g[23]) // g is a Graph<String>
```

Note: At this time, graphs are *not* thread-safe. However, once a graph is constructed, if you will only be doing lookups and searches through it (no removals of vertices/edges and no additions of vertices/edges) then you should be able to do that from multiple threads. A fully thread-safe graph implementation is a possible future direction.

* `Graph` (Protocol) - This is the base protocol for all graphs.  Generally, you should use one of its canonical class implementations, `UnweightedGraph` or `WeightedGraph`, instead of rolling your own adopter, because they offer significant built-in functionality. The vertices in a `Graph` (defined as a generic at graph creation time) can be of any type that conforms to `Equatable` and `Codable`. All `Graph`s are `Codable`.  `Graph` has methods for:
  * Adding a vertex
  * Getting the index of a vertex
  * Finding the neighbors of an index/vertex
  * Finding the edges of an index/vertex
  * Checking if an edge from one index/vertex to another index/vertex exists
  * Checking if a vertex is in the graph
  * Adding an edge
  * Removing all edges between two indexes/vertices
  * Removing a particular vertex (all other edge relationships are automatically updated at the same time (because the indices of their connections changes) so this is slow - O(v + e) where v is the number of vertices and e is the number of edges)
* `UnweightedGraph` - A generic class implementation of `Graph` that adds convenience methods for adding and removing edges of type `UnweightedEdge`. `UnweightedGraph` is generic over the type of the vertices.
* `WeightedGraph` - A generic class implementation of `Graph` that adds convenience methods for adding and removing edges of type `WeightedEdge`. `WeightedGraph` also adds a method for returning a list of tuples containing all of the neighbor vertices of an index along with their respective weights. `WeightedGraph` is generic over the types of the vertices and its weights.
* `UniqueElementsGraph` - a `Graph` implementation with support for union operations that ensures all vertices and edges in a graph are unique.

### Search
Search methods are defined in extensions of `Graph` and `WeightedGraph` in `Search.swift`.
* `bfs()` (method on `Graph`) - Finds a path from one vertex to another in a `Graph` using a breadth-first search. Returns an array of `Edge`s going from the source vertex to the destination vertex or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a vertex and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first vertex that returns true from `goalTest()`.
* `dfs()` (method on `Graph`) - Finds a path from one vertex to another in a `Graph` using a depth-first search. Returns an array of `Edge`s going from the source vertex to the destination vertex or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a vertex and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first vertex that returns true from `goalTest()`.
* `findAll()` Uses a breadth-first search to find all connected vertices from the starting vertex that return true when run through a `goalTest()` function. Paths to the connected vertices are returned in an array, which is empty if no vertices are found.
* `dijkstra()` (method on `WeightedGraph`) - Finds the shortest path from a starting vertex to every other vertex in a `WeightedGraph`. Returns a tuple who's first element is an array of the distances to each vertex in the graph arranged by index. The second element of the tuple is a dictionary mapping graph indices to the previous `Edge` that gets them there in the shortest time from the staring vertex. Using this dictionary and the function `pathDictToPath()`, you can find the shortest path from the starting vertex to any other connected vertex. See the `dijkstra()` unit tests in `DijkstraGraphTests.swift` for a demo of this.
* Graph traversal versions of `bfs()` and `dfs()` that allow a visit function to execute at each stop

### Sort & Miscellaneous
An extension to `Graph` in `Sort.swift` provides facilities for topological sort and detecting a DAG.
* `topologicalSort()` - Does a topological sort of the vertices in a given graph if possible (returns nil if it finds a cycle). Returns a sorted list of the vertices. Runs in O(n) time.
* `isDAG` - A property that uses `topologicalSort()` to determine whether a graph is a DAG (directed-acyclic graph). Runs in O(n) time.

An extension to `WeightedGraph` in `MST.swift` can find a minimum-spanning tree from a weighted graph.
* `mst()` - Uses Jarnik's Algorithm (aka Prim's Algorithm) to find the tree made of minimum cumulative weight that connects all vertices in a weighted graph. This assumes the graph is completely undirected and connected. If the graph has directed edges, it may not return the right answer. Also, if the graph is not fully connected it will create the tree for the connected component that the starting vertex is a part of. Returns an array of `WeightedEdge`s that compose the tree. Use utility functions `totalWeight()` and `printMST()` to examine the returned MST. Runs in O(n lg n) time.

An extension to `Graph` in `Cycles.swift` finds all of the cycles in a graph.
* `detectCycles()` - Uses an algorithm developed by Liu/Wang to find all of the cycles in a graph. Optionally, this method can take one parameter, `upToLength`, that specifies a length at which to stop searching for cycles. For instance, if `upToLength` is 3, `detectCycles()` will find all of the 1 vertex cycles (self-cycles, vertices with edges to themselves), and 3 vertex cycles (connection to another vertex and back again, present in all undirected graphs with more than 1 vertex). There is no such thing as a 2 vertex cycle.

An extension to `Graph` in `Reversed.swift` reverses all of the edges in a graph.

## Authorship, License, & Contributors
SwiftGraph is written by David Kopec and other contributors (see `CONTRIBUTORS.md`). It is released under the Apache License (see `LICENSE`). You can find my email address on my GitHub profile page. I encourage you to submit pull requests and open issues here on GitHub. 

I would like to thank all of the contributors who have helped improve SwiftGraph over the years, and have kept me motivated. Contributing to SwiftGraph, in-line with the Apache license, means also releasing your contribution under the same license as the original project. However, the Apache license is permissive, and you are free to include SwiftGraph in a commercial, closed source product as long as you give it & its author credit (in fact SwiftGraph has already found its way into several products). See `LICENSE` for details.

If you use SwiftGraph in your product, please let me know by getting in touch with me. It's just cool to know.

## Future Direction
Future directions for this project to take could include:
* More utility functions
* A thread safe implementation of `Graph`
* More extensive performance testing
* GraphML and Other Format Support
