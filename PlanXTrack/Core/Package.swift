// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Core",
    platforms: [.macOS(.v14), .iOS(.v18)],
    products: [
        .library(
            name: "Core",
            targets: [
                "Core",
                "CoreAssemble",
                "CoreTesting",
            ]
        ),
    ],
    dependencies: [
        .package(name: "Storage", path: "../Storage"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Core",
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "CoreAssemble",
            dependencies: [
                .product(name: "Storage", package: "Storage")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "CoreTesting",
            dependencies: ["Core"],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "CoreTests",
            dependencies: [
                "Core",
                "CoreAssemble"
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
