// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HIDEngine",
    platforms: [.macOS(.v10_15)],
    products: [.library(name: "HIDEngine", type: .dynamic, targets: ["HIDEngine"])],
    targets: [
        .systemLibrary(name: "Chidapi", path: "./Sources/Chidapi", pkgConfig: "hidapi", providers: [.brew(["hidapi"])]),
        .target(name: "HIDEngine", dependencies: [.target(name: "Chidapi")])
    ]
)
