// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationCoordinatable",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "NavigationCoordinatable", targets: ["NavigationCoordinatable"]),
    ],
    targets: [
        .target(name: "NavigationCoordinatable"),
    ],
    swiftLanguageVersions: [.v5]
)
