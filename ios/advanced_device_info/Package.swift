// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "advanced_device_info",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "advanced-device-info", targets: ["advanced_device_info"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "advanced_device_info",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
