// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "parallax-scrollview",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "ParallaxScrollView",
            targets: ["ParallaxScrollView"]
        ),
    ],
    targets: [
        .target(name: "ParallaxScrollView")
    ]
)
