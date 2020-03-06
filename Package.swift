// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftGraph",
    products: [
        .library(
            name: "SwiftGraph",
            targets: ["SwiftGraph"]),
        .library(
            name: "SwiftGraphGenerators",
            targets: ["SwiftGraphGenerators"]),
        ],
    dependencies: [
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "SwiftGraph",
            dependencies: []),
        .target(
            name: "SwiftGraphGenerators",
            dependencies: ["SwiftCheck"]),
        .testTarget(
            name: "SwiftGraphTests",
            dependencies: ["SwiftGraph", "SwiftCheck", "SwiftGraphGenerators"]),
        .testTarget(
            name: "SwiftGraphPerformanceTests",
            dependencies: ["SwiftGraph"]),
        ]
)
