// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScrollControl",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "ScrollControl",
            targets: ["ScrollControl"]
        )
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .executableTarget(
            name: "ScrollControl",
            dependencies: [],
            path: "Sources/ScrollControl"
        )
    ]
)