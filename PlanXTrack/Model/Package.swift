// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Model",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(
            name: "Model",
            targets: ["Model"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Model",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
