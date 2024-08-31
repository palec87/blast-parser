//
//  Package.swift
//  blast_parser
//
//  Created by João Varela on 31/08/2024.
//

import PackageDescription

let package = Package(
    name: "BlastParser",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "blast_parser",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
    ]
)
