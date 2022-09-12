//
//  JSONIconography.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import Foundation
import SwiftUI

final class JSONIconography: Iconography, Decodable {

    enum Icon {

        case system(_ name: String)
        case bundle(_ name: String)
        case asset(_ name: String)
    }

    private let bundle: Bundle
    private let icons: [IconographyType: Icon] = [
        .trash: .system("trash")
    ]

    init(bundle: Bundle = Bundle.main) {
        self.bundle = bundle
    }

    func icon(for type: IconographyType, darkMode: Bool) -> Image {

        let icon = self.icons[type] ?? .system("questionmark.app.fill")

        switch icon {

        case .system(let name):
            return Image(systemName: name)

        case .bundle(let name):
            return Image(name, bundle: self.bundle)

        case .asset(let name):
            return Image(name)
        }
    }

    init(from decoder: Swift.Decoder) throws {
        self.bundle = .main
    }
}

// MARK: - Defaults

extension JSONIconography {

    static let `default` = JSONIconography()
}
