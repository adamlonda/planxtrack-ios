// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Assemble",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(
            name: "Assemble",
            targets: ["Assemble"]
        ),
    ],
    dependencies: [
        .package(name: "Core", path: "../Core"),
        .package(name: "Storage", path: "../Storage"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Assemble",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Storage", package: "Storage")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "AssembleTests",
            dependencies: ["Assemble"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
