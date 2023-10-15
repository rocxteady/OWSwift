// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OWSwift",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OWSwift",
            targets: ["OWSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/rocxteady/Resting.git", .upToNextMajor(from: "0.0.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OWSwift",
            dependencies: ["Resting"],
            resources: [.process("Resources/Mocks")]
        ),
        .testTarget(
            name: "OWSwiftTests",
            dependencies: ["OWSwift"]),
    ]
)