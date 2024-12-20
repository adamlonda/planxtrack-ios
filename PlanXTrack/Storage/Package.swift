// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Storage",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(
            name: "Storage",
            targets: [
                "Storage",
                "StorageMocks",
                "StorageImplementation"
            ]
        ),
    ],
    dependencies: [
        .package(name: "Model", path: "../Model"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Storage",
            dependencies: [
                .product(name: "Model", package: "Model")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "StorageMocks",
            dependencies: [
                "Storage",
                .product(name: "Model", package: "Model")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "StorageImplementation",
            dependencies: [
                "Storage",
                .product(name: "Model", package: "Model")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "StorageTests",
            dependencies: [
                "Storage",
                "StorageImplementation",
                "StorageMocks"
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        )
    ]
)
