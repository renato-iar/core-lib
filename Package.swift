// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: .init(stringLiteral: "9.0.0")))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
    ]
)

// Modules definition

enum Modules: String {
    case adService = "AdService"
    case cache = "Cache"
    case charting = "Charting"
    case fileSystem = "FileSystem"
    case localization = "Localization"
    case logging = "Logging"
    case networking = "Networking"
    case theming = "Theming"
    case useCases = "UseCases"
    case utilities = "Utilities"

    var concreteName: String { self.rawValue }
    var concretePath: String { self.concreteName + "/Concrete" }

    var basePath: String { self.concreteName }

    var apiName: String { self.concreteName + "_API" }
    var apiPath: String { self.concreteName + "/API" }

    var testsName: String { self.concreteName + "_Tests" }
    var testsPath: String { self.concreteName + "/Tests" }

    var mockName: String { self.concreteName + "_Mock" }
    var mockPath: String { self.concreteName + "/Mock" }

    var payloadsPath: String { "Payloads" }

    func concretePath(_ extended: String) -> String {
        self.concretePath + "/" + extended
    }
    func concreteName(_ extended: String) -> String {
        self.concreteName + extended
    }

    func payload(_ name: String) -> String { self.payloadsPath + "/" + name }
}

// MARK: - AdService
/*
package.targets.append(contentsOf: [
    .target(name: Modules.adService.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.theming.apiName),
                .init(stringLiteral: Modules.theming.concreteName("_UIKit")),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: Modules.adService.basePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.adService.concreteName,
             targets: [Modules.adService.concreteName])
])
*/

// MARK: - Cache

package.targets.append(contentsOf: [
    .target(name: Modules.cache.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.fileSystem.apiName),
                .init(stringLiteral: Modules.networking.apiName)
            ],
            path: Modules.cache.apiPath),
    .target(name: Modules.cache.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.fileSystem.apiName),
                .init(stringLiteral: Modules.fileSystem.concreteName),
                .init(stringLiteral: Modules.networking.apiName),
                .init(stringLiteral: Modules.networking.concreteName),
                .init(stringLiteral: Modules.cache.apiName)
            ],
            path: Modules.cache.concretePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.cache.apiName,
             targets: [Modules.cache.apiName]),
    .library(name: Modules.cache.concreteName,
             targets: [Modules.cache.concreteName])
])

// MARK: - FileSystem

package.targets.append(contentsOf: [
    .target(name: Modules.fileSystem.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName)
            ],
            path: Modules.fileSystem.apiPath),
    .target(name: Modules.fileSystem.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.basePath),
                .init(stringLiteral: Modules.fileSystem.apiName)
            ],
            path: Modules.fileSystem.concretePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.fileSystem.apiName,
             targets: [Modules.fileSystem.apiName]),
    .library(name: Modules.fileSystem.concreteName,
             targets: [Modules.fileSystem.concreteName])
])

// MARK: - Localization

package.targets.append(contentsOf: [
    .target(name: Modules.localization.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName)
            ],
            path: Modules.localization.apiPath),
    .target(name: Modules.localization.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.localization.apiName),
                .init(stringLiteral: Modules.cache.apiName),
                .init(stringLiteral: Modules.cache.concreteName),
                .init(stringLiteral: Modules.logging.apiName),
                .init(stringLiteral: Modules.logging.concreteName)
            ],
            path: Modules.localization.concretePath),
    .target(name: Modules.localization.mockName,
            dependencies: [
                .init(stringLiteral: Modules.localization.apiName),
                .init(stringLiteral: Modules.localization.concreteName)
            ],
            path: Modules.localization.mockPath)
])

package.products.append(contentsOf: [
    .library(name: Modules.localization.apiName,
             targets: [Modules.localization.apiName]),
    .library(name: Modules.localization.concreteName,
             targets: [Modules.localization.concreteName]),
    .library(name: Modules.localization.mockName,
             targets: [Modules.localization.mockName])
])

// MARK: - Logging

package.targets.append(contentsOf: [
    .target(name: Modules.logging.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName)
            ],
            path: Modules.logging.apiPath),
    .target(name: Modules.logging.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.logging.apiName),
            ],
            path: Modules.logging.concretePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.logging.apiName,
             targets: [Modules.logging.apiName]),
    .library(name: Modules.logging.concreteName,
             targets: [Modules.logging.concreteName])
])

// MARK: - Networking

package.targets.append(contentsOf: [
    .target(name: Modules.networking.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.useCases.concreteName)
            ],
            path: Modules.networking.apiPath),
    .target(name: Modules.networking.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.networking.apiName),
                .init(stringLiteral: Modules.useCases.concreteName)
            ],
            path: Modules.networking.concretePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.networking.apiName,
             targets: [Modules.networking.apiName]),
    .library(name: Modules.networking.concreteName,
             targets: [Modules.networking.concreteName])
])

// MARK: - Theming

package.targets.append(contentsOf: [
    .target(name: Modules.theming.apiName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName)
            ],
            path: Modules.theming.apiPath),
    .target(name: Modules.theming.concreteName("_SwiftUI"),
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.theming.apiName)
            ],
            path: Modules.theming.concretePath("SwiftUI")),
    .target(name: Modules.theming.concreteName("_UIKit"),
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
                .init(stringLiteral: Modules.theming.apiName)
            ],
            path: Modules.theming.concretePath("UIKit"))
])

package.products.append(contentsOf: [
    .library(name: Modules.theming.apiName,
             targets: [Modules.theming.apiName]),
    .library(name: Modules.theming.concreteName("_SwiftUI"),
             targets: [Modules.theming.concreteName("_SwiftUI")]),
    .library(name: Modules.theming.concreteName("_UIKit"),
             targets: [Modules.theming.concreteName("_UIKit")])
])


// MARK: - Charting

package.targets.append(contentsOf: [
    .target(name: Modules.charting.concreteName,
            dependencies: [
                .init(stringLiteral: Modules.utilities.concreteName),
            ],
            path: Modules.charting.concretePath)
])

package.products.append(contentsOf: [
    .library(name: Modules.charting.concreteName,
             targets: [Modules.charting.concreteName])
])

// MARK: - UseCases

package.targets.append(contentsOf: [
    .target(name: Modules.useCases.concreteName,
            dependencies: [],
            path: Modules.useCases.apiPath),
])

package.products.append(contentsOf: [
    .library(name: Modules.useCases.concreteName,
             targets: [Modules.useCases.concreteName])
])

// MARK: - Utilities

package.targets.append(contentsOf: [
    .target(name: Modules.utilities.concreteName,
            dependencies: [],
            path: Modules.utilities.basePath),
])

package.products.append(contentsOf: [
    .library(name: Modules.utilities.concreteName,
             targets: [Modules.utilities.concreteName])
])
