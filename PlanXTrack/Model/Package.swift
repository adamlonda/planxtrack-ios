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
        .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.10.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.57.1")
    ],
    targets: [
        .target(
            name: "Model",
            dependencies: [
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "TaggedTime", package: "swift-tagged")
            ],
            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
    ]
)
