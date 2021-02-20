# History and Contributors

The purpose of this document is to keep track of where SwiftGraph came from, how it's being used, and who is working on it.

## Brief History

SwiftGraph was originally created by me (David Kopec @davecom on GitHub) in 2014 shortly after Swift was publicly released, and I've been maintaining it ever since. It has been upgraded and expanded through every Swift version, starting with Swift 1.0. SwiftGraph is part of the [Swift Source Compatibility Suite](https://swift.org/source-compatibility/#current-list-of-projects). Chapter 4 of my book, [*Classic Computer Science Problems in Swift*](https://github.com/davecom/ClassicComputerScienceProblemsInSwift), published in April 2018, is based on a simplified version of SwiftGraph.

## Uses

SwiftGraph is being used in several real-world and hobby projects. The most notable that I am aware of is probably the [Wayfindr demo app](https://github.com/wayfindrltd/wayfindr-demo-ios), which is used for assisting vision impaired people with navigating environments. If you are using SwiftGraph in your application, we'd love to hear about it. Perhaps we can start a list in this document.

## Contributors

SwiftGraph has been worked on by the following people:
- David Kopec (@davecom) - I started the project in 2014 and I have been maintaining it ever since; I wrote most of the code between 2014-2017
- Ferran Pujol Camins (@ferranpujolcamins) - Ferran got us setup with continuous integration, added the `UniqueVerticesGraph` class and its supporting machinery, refactored some of the search algorithms, cleaned up several miscellaneous sections, and is working on Graphviz support. He was the primary force behind SwiftGraph in 2018-2019.
- Zev Eisenberg (@ZevEisenberg) - Added the original cycle detection algorithms and provided miscellaneous bug fixes.
- Kevin Lundberg (@klundberg) - Added Carthage support.
- Ian Grossberg (@yoiang) - Helped with Codable support
- Devin Abbott (@dabbott) - Improved the performance of `topologicalSort()`
- Matt Paletta (@mattpaletta) - Added `reversed()`

Thank you to everyone who has contributed, including those not listed, who made smaller contributions. If I forgot you and you made a significant contribution to SwiftGraph, please make a pull request to this document.

### Designated Successor

Should I become incapacitated, or for some reason I stop responding for more than six months, it's my wish that Ferran takeover the project. If SwiftGraph becomes more popular and we need a more sophisticated governance structure, I'm happy to put that in place.
