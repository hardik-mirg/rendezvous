// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "Rendezvous",
    dependencies: [
        // Dependencies for cross-platform development
    ],
    targets: [
        .target(
            name: "Rendezvous",
            dependencies: [],
            path: "Sources/Rendezvous",
            resources: [
                .copy("librendezvous_core.dylib")
            ],
            linkerSettings: [
                .linkedLibrary("rendezvous_core"),
            ]
        ),
        .testTarget(
            name: "RendezvousTests",
            dependencies: [],
            path: "Tests"
        )
    ]
)