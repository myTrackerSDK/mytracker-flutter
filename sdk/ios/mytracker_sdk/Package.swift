// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mytracker_sdk",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "mytracker-sdk", targets: ["mytracker_sdk"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/myTrackerSDK/mytracker-ios-spm.git", exact: "3.2.0")
    ],
    targets: [
        .target(
            name: "mytracker_sdk",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "MyTrackerSDK", package: "mytracker-ios-spm")
            ],
            cSettings: [
                .headerSearchPath("include/mytracker_sdk")
            ]
        )
    ]
)
