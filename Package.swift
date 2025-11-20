// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "swift-pesel",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_13),
    .tvOS(.v12),
    .watchOS(.v4),
  ],
  products: [
    .library(
      name: "Pesel",
      targets: ["Pesel"]
    ),
  ],
  targets: [
    .target(name: "Pesel"),
    .testTarget(
      name: "PeselTests",
      dependencies: ["Pesel"]
    ),
  ],
  swiftLanguageModes: [
    .v6
  ]
)
