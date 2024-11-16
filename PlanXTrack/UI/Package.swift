// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.0")
    ],
    targets: [
        .target(
            name: "UI",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
