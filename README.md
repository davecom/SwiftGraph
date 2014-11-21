# SwiftGraph

SwiftGraph is a pure Swift (no Cocoa) implementation of a graph data structure, appropriate for use on both iOS and OS X projects. It includes support for weighted, unweighted, directed, and undirected graphs. It uses generics to abstract away both the class of the vertices, and the class of weights.

It includes copious in-source documentation, some unit tests, as well as utility functions for doing things like breadth-first search, depth-first search, and djikstra's algorithm.

## Installation
Simply copy `SwiftGraph.swift` into your project. When the Swift packaging story improves, SwiftGraph will improve with it, but for now it seemed the easiest thing to do was to put the entire library in one file.

## Tips and Tricks
* To get a sense of how to use SwiftGraph, checkout the unit tests.
* Inserting an edge by vertex indices is much faster than inserting an edge by vertex objects that need to have their indices looked up.
* Generally looking for the index of a vertex is O(n) time, with n being the number of vertices in the graph.
* SwiftGraph includes the functions bfs() and dfs() for finding a route between one vertex and another in a graph.
* The impelementation of djikstra's algorithm done with the function 
* Is the sample program (Nine Tails) beachballing and taking a few seconds to load for you? Edit the Run scheme to be Release instead of Debug.

## Documentation
There is a large amount of documentation in the source code using the latest Apple documentation technique - so you should be able to just alt-click a method name to get a lot of great information about it.  Unfortunately there's no good way to turn that documentation into HTML/Markdown at this time. Until tools come out to do this, here's some more basic information

### Edges
* *`Edge`* (Protocol) - A protocol that all edges in a graph must conform to. An edge is a connection between two vertices in the graph. The vertices are specified by their index in the graph which is an integer. Further, an edge knows if it's directed, or weighted. An edge can create a reversed version of itself.
* *`UnweightedEdge`* - This is a concrete implementation of `Edge` for unweighted graphs.
* *`WeightedEdge`* - A subclass of `UnweightedEdge` that adds weights. Weights are a generic type - they can be anything that implements `Comparable` and `Summable`.  `Summable` is anything that implements the `+` operator.  To add `Summable` support to a data type that already has the plus operator, simply right something like
```
extension Int: Summable {}
```
