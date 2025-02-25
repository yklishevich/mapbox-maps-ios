// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MapboxMaps",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "MapboxMaps",
            targets: ["MapboxMaps"]),
    ],
    dependencies: [
        .package(name: "MapboxCoreMaps", url: "https://github.com/mapbox/mapbox-core-maps-ios.git", .exact("10.0.0-beta.23")),
        .package(name: "MapboxMobileEvents", url: "https://github.com/mapbox/mapbox-events-ios.git", .exact("1.0.2")),
        .package(name: "Turf", url: "https://github.com/mapbox/turf-swift.git", .exact("2.0.0-alpha.3")),
    ],
    targets: [
        .target(
            name: "MapboxMaps",
            dependencies: ["MapboxCoreMaps", "Turf", "MapboxMobileEvents"],
            exclude: [
                "MapView/Info.plist",
                "Style/README.md",
            ]
        ),
        .testTarget(
            name: "MapboxMapsTests",
            dependencies: ["MapboxMaps"],
            exclude: [
                "MapView/Info.plist",
                "MapView/Integration Tests/HTTP/HTTPIntegrationTests.swift",
            ],
            resources: [
                .copy("Foundation/GeoJSON/Fixtures/point.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/multipoint.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/multiline.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/geometry-collection.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/featurecollection.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/featurecollection-no-properties.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/simple-line.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/polygon.geojson"),
                .copy("Foundation/GeoJSON/Fixtures/multipolygon.geojson"),
                .copy("Helpers/MapboxAccessToken"),
                .copy("Resources/empty-style-chicago.json"),
                .copy("Resources/Snapshot-Asset.png"),
                .process("Resources/MapInitOptionsTests.xib"),
            ]
        )
    ]
)
