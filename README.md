# SwiftGraph

SwiftGraph is a pure Swift (no Cocoa) implementation of a graph data structure, appropriate for use on all platforms Swift supports (iOS, OS X, Linux, etc.). It includes support for weighted, unweighted, directed, and undirected graphs. It uses generics to abstract away both the type of the vertices, and the type of the weights.

It includes copious in-source documentation, unit tests, as well as search functions for doing things like breadth-first search, depth-first search, and dijkstra's algorithm. Further, it includes utility functions for topological sort and detecting a DAG (directed-acyclic-graph).

## Installation

SwiftGraph 1.1.0 and above requires Swift 3 (Xcode 8). SwiftGraph 1.0.1 through 1.0.6 requires Swift 2 (Xcode 7). For Swift 1.2 support (Xcode 6.3) use version 1.0 of SwiftGraph.

### CocoaPods

Use the CocoaPod `SwiftGraph`.

### Carthage

Add the following to your `Cartfile`:

```
github "davecom/SwiftGraph" ~> 1.3.0
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

## Documentation
There is a large amount of documentation in the source code using the latest Apple documentation technique - so you should be able to just alt-click a method name to get a lot of great information about it in Xcode. There are up-to-date HTML docs available online thanks to the good folks at [CocoaPods](http://cocoadocs.org/docsets/SwiftGraph/) In addition, here's some more basic information:

### Edges
Edges connect the vertices in your graph to one another.

* `Edge` (Protocol) - A protocol that all edges in a graph must conform to. An edge is a connection between two vertices in the graph. The vertices are specified by their index in the graph which is an integer. Further, an edge knows if it's directed, or weighted. An edge can create a reversed version of itself.
* `UnweightedEdge` - This is a concrete implementation of `Edge` for unweighted graphs.
* `WeightedEdge` - A subclass of `UnweightedEdge` that adds weights. Weights are a generic type - they can be anything that implements `Comparable` and `Summable`.  `Summable` is anything that implements the `+` operator.  To add `Summable` support to a data type that already has the plus operator, simply write something like (support in SwiftGraph is already included for `Int`, `Float`, `Double`, and `String`):
```
extension Int: Summable {}
```

### Graphs
Graphs are the data structures at the heart of SwiftGraph. All vertices are assigned an integer index when they are inserted into a graph and it's generally faster to refer to them by their index than by the vertex's actual object.

Graphs implement the standard Swift protocols `SequenceType` (for iterating through all vertices) and `CollectionType` (for grabbing a vertex by its index through a subscript). For instance, the following example prints all vertices in a Graph on separate lines:
```
for v in g {  // g is a Graph<String>
    println(v)
}
```
And we can grab a specific vertex by its index using a subscript
```
println(g[23]) // g is a Graph<String>
```

Note: At this time, graphs are *not* thread-safe. However, once a graph is constructed, if you will only be doing lookups and searches through it (no removals of vertices/edges and no additions of vertices/edges) then you should be able to do that from multiple threads. A fully thread-safe graph implementation is a possible future direction.

* `Graph` - This is the base class for all graphs.  Generally, you should use one of its canonical subclasses, `UnweightedGraph` or `WeightedGraph`, because they offer more functionality. The vertices in a `Graph` (defined as a generic at graph creation time) can be of any type that conforms to `Equatable`. `Graph` has methods for:
  * Adding a vertex
  * Getting the index of a vertex
  * Finding the neighbors of an index/vertex
  * Finding the edges of an index/vertex
  * Checking if an edge from one index/vertex to another index/vertex exists
  * Checking if a vertex is in the graph
  * Adding an edge
  * Removing all edges between two indexes/vertices
  * Removing a particular vertex (all other edge relationships are automatically updated at the same time (because the indices of their connections changes) so this is slow - O(v + e) where v is the number of vertices and e is the number of edges)
* `UnweightedGraph` - A subclass of `Graph` that adds convenience methods for adding and removing edges of type `UnweightedEdge`.
* `WeightedGraph` - A subclass of `Graph` that adds convenience methods for adding and removing edges of type `WeightedEdge`. `WeightedGraph` also adds a method for returning a list of tuples containing all of the neighbor vertices of an index along with their respective weights.

### Search
Search methods are defined in extensions of `Graph` and `WeightedGraph` in `Search.swift`.
* `bfs()` (method on `Graph`) - Finds a path from one vertex to another in a `Graph` using a breadth-first search. Returns an array of `Edge`s going from the source vertex to the destination vertex or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a vertex and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first vertex that returns true from `goalTest()`.
* `dfs()` (method on `Graph`) - Finds a path from one vertex to another in a `Graph` using a depth-first search. Returns an array of `Edge`s going from the source vertex to the destination vertex or an empty array if no path could be found. A version of this method takes a function, `goalTest()`, that operates on a vertex and returns a boolean to indicate whether it is a goal for the search. It returns a path to the first vertex that returns true from `goalTest()`.
* `findAll()` Uses a breadth-first search to find all connected vertices from the starting vertex that return true when run through a `goalTest()` function. Paths to the connected vertices are returned in an array, which is empty if no vertices are found.
* `dijkstra()` (method on `WeightedGraph`) - Finds the shortest path from a starting vertex to every other vertex in a `WeightedGraph`. Returns a tuple who's first element is an array of the distances to each vertex in the graph arranged by index. The second element of the tuple is a dictionary mapping graph indices to the previous `Edge` that gets them there in the shortest time from the staring vertex. Using this dictionary and the function `pathDictToPath()`, you can find the shortest path from the starting vertex to any other connected vertex. See the `dijkstra()` unit tests in `DijkstraGraphTests.swift` for a demo of this.

### Sort & Miscellaneous
An extension to `Graph` in `Sort.swift` provides facilities for topological sort and detecting a DAG.
* `topologicalSort()` - Does a topological sort of the vertices in a given graph if possible (returns nil if it finds a cycle). Returns a sorted list of the vertices. Runs in O(n) time.
* `isDAG` - A property that uses `topologicalSort()` to determine whether a graph is a DAG (directed-acyclic graph). Runs in O(n) time.


## Authorship & License
SwiftGraph is written by David Kopec and released under the Apache License (see `LICENSE`). You can find my email address on my GitHub profile page. I encourage you to submit pull requests and open issues here on GitHub.

## Future Direction
Future directions for this project to take could include:
* More utility functions
* A thread safe subclass of `Graph`
* More extensive performance testing
