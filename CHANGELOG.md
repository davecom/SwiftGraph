### 1.4.0
- Added a Minimum Spanning Tree Fuction `mst()` based on Jarnik's Algorithm (aka Prim's Algorithm)
- Simplified Dijkstra's Algorithm implementation

### 1.3.1
- Fixes a bug that could result in the wrong edges being removed when a vertex is removed (thanks @brandonroth)
- Silences some warnings about printing optionals introduced in Swift 3.1

### 1.3.0
- Carthage Support (via re-organizing into framework) - thanks @klundberg
- New search methods added - versions of `bfs()` and `dfs()` that support custom goal functions
- `findAll()` added as a version of `bfs()` with multiple potential outcomes 
- watchOS support added to Podfile

### 1.2.0
- Moved search functions from free functions to extensions of `Graph` and `WeightedGraph`
- Switched license to Apache 2.0 from MIT
- Added `topologicalSort()` and `isDAG`
- Changed access level for most types to `open`
- Added unit tests for topologicalSort and isDAG

### 1.1.1
- Fixes for the final version of Swift 3
- Updated version of SwiftPriorityQueue
- Added .swift-version file

### 1.1.0
- Requires Swift 3
- Minor breaking API naming changes in-line with Swift 3 expectations
- `dijkstra()` has a parameter for the starting distance to the root vertex (typically zero)
- Updated the included SwiftPriorityQueue source file

### 1.0.6
- Last version to support Swift 2
- Switched `dijkstra()` to use a priority queue
- Included the source file for SwiftPriorityQueue in the project

### 1.0.5
- Fixed build issues on Xcode 7.3

### 1.0.4
- Fixed Swift 3 deprecations
- Added SPM support

### 1.0.3
- Separated SwiftGraph into multiple files 
- Fixed some documentation.
- Made `edges` and `vertices` internal instead of private

### 1.0.2
Fixed the misspelling of Dijkstra

### 1.0.1
Updated to support Swift 2

### 1.0
Initial Stable Release - last release with Swift 1.2 support
