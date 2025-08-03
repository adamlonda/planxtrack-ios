// swift-tools-version: 6.1

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
        .package(name: "Reducers", path: "../Reducers"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                .product(name: "Reducers", package: "Reducers")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
