// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonMarkAttributedString",
    products: [
        .library(
            name: "CommonMarkAttributedString",
            targets: ["CommonMarkAttributedString"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftDocOrg/CommonMark.git", from: "0.2.2"),
    ],
    targets: [
        .target(
            name: "CommonMarkAttributedString",
            dependencies: ["CommonMark"]),
        .testTarget(
            name: "CommonMarkAttributedStringTests",
            dependencies: ["CommonMarkAttributedString"]),
    ]
)
