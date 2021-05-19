// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Meshy",
    platforms: [
        .iOS(.v13),
        .macOS(SupportedPlatform.MacOSVersion.v10_15)
    ],
    products: [
        .library(
            name: "Meshy",
            targets: ["Meshy"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CMeshy",
            dependencies: []),
        .target(
            name: "Meshy",
            dependencies: ["CMeshy"]),
        .testTarget(
            name: "MeshyTests",
            dependencies: ["CMeshy", "Meshy"]),
    ]
)
