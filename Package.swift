// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Notifications",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "Notifications",
            targets: ["Notifications"]),
    ],
    targets: [
        .target(
            name: "Notifications"),
    ]
)
