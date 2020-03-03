// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SwiftGraph",
    products: [
        .library(
            name: "SwiftGraph",
            targets: ["SwiftGraph"]),
        ],
    dependencies: [
        .package(url: "https://github.com/typelift/SwiftCheck.git", from: "0.12.0")
    ],
    targets: [
        .target(
            name: "SwiftGraph",
            dependencies: []),
        .testTarget(
            name: "SwiftGraphTests",
            dependencies: ["SwiftGraph", "SwiftCheck"]),
        .testTarget(
            name: "SwiftGraphPerformanceTests",
            dependencies: ["SwiftGraph"]),
        ]
)
