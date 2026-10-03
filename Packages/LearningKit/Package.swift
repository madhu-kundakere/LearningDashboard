// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LearningKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "MockBackend", targets: ["MockBackend"]),
        .library(name: "Persistence", targets: ["Persistence"]),
        .library(name: "DataLayer", targets: ["DataLayer"]),
        .library(name: "DesignSystem", targets: ["DesignSystem"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "CoursesFeature", targets: ["CoursesFeature"]),
    ],
    targets: [
        .target(name: "Core", resources: [.process("Resources")]),
        .target(name: "Domain", dependencies: ["Core"]),
        .target(name: "Networking", dependencies: ["Core"]),
        .target(name: "MockBackend", dependencies: ["Core", "Networking"], resources: [.process("Resources")]),
        .target(name: "Persistence"),
        .target(name: "DataLayer", dependencies: ["Core", "Domain", "Networking", "Persistence"]),
        .target(name: "DesignSystem", dependencies: ["Core"], resources: [.process("Resources")]),
        .target(name: "AuthFeature", dependencies: ["Core", "Domain", "DesignSystem"], resources: [.process("Resources")]),
        .target(name: "CoursesFeature", dependencies: ["Core", "Domain", "DesignSystem"], resources: [.process("Resources")]),
        .testTarget(name: "DomainTests", dependencies: ["Core", "Domain"]),
        .testTarget(name: "DataLayerTests", dependencies: ["Core", "Domain", "Networking", "Persistence", "DataLayer"]),
        .testTarget(name: "AuthFeatureTests", dependencies: ["Core", "Domain", "AuthFeature"]),
        .testTarget(name: "CoursesFeatureTests", dependencies: ["Core", "Domain", "CoursesFeature"]),
    ]
)
