// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Rendezvous",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "Rendezvous",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/Rendezvous",
            resources: [
                .copy("librendezvous_core.dylib"),
                .process("ComponentData"),
                .process("Assets")
            ],
            linkerSettings: [
                .unsafeFlags(["-L", "Sources/Rendezvous", "-lrendezvous_core"])
            ]
        ),
        .testTarget(
            name: "RendezvousTests",
            dependencies: ["Rendezvous"],
            path: "Tests"
        )
    ]
)