// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "insta_assets_crop",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "insta-assets-crop", targets: ["insta_assets_crop"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "insta_assets_crop",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            cSettings: [
                .headerSearchPath("include/insta_assets_crop")
            ]
        )
    ]
)
