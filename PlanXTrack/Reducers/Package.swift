// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Reducers",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(
            name: "Reducers",
            targets: ["Reducers"]
        ),
    ],
    dependencies: [
        .package(name: "Convenience", path: "../Convenience"),
        .package(name: "Core", path: "../Core"),
        .package(name: "Storage", path: "../Storage"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Reducers",
            dependencies: [
                .product(name: "Convenience", package: "Convenience"),
                .product(name: "Core", package: "Core"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "Storage", package: "Storage")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "ReducersTests",
            dependencies: [
                "Reducers",
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
