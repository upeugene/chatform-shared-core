// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chatform-shared-core",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "chatform-shared-core",
            targets: ["chatform-shared-core"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "chatform-shared-core"),
        .testTarget(
            name: "chatform-shared-coreTests",
            dependencies: ["chatform-shared-core"]),
    ]
)