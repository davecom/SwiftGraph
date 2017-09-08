// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftGraph",
    products: [
        .library(
            name: "SwiftGraph",
            targets: ["SwiftGraph"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftGraph",
            dependencies: []),
        .testTarget(
            name: "SwiftGraphTests",
            dependencies: ["SwiftGraph"]),
    ]
)
