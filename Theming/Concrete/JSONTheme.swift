//
//  Theme.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 14/08/2022.
//

import Foundation
import SwiftUI

public final class JSONTheme: Theme, Decodable {

    public private(set) var name: String

    public private(set) var palette: any ColorPalette
    public private(set) var typography: any Typography
    public private(set )var icongraphy: any Iconography
    public let gallery: any Gallery =  JSONGallery()

    // MARK: Initializers

    init(name: String,
         palette: any ColorPalette,
         typography: any Typography,
         iconography: any Iconography) {

        self.name = name
        self.palette = palette
        self.typography = typography
        self.icongraphy = iconography
    }

    // MARK: Decodable

    private enum CodingKeys: String, CodingKey {

        case name
        case palette
        case typography
        case iconography
    }

    public init(from decoder: Swift.Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.palette = try container.decode(JSONPalette.self, forKey: .palette)
        self.typography = try container.decode(JSONTypography.self, forKey: .typography)
        self.icongraphy = try container.decode(JSONIconography.self, forKey: .iconography)
    }
}

// MARK: - Defaults

extension JSONTheme: Shareable {

    static public var shared = JSONTheme(name: "Default",
                                         palette: JSONPalette.default,
                                         typography: JSONTypography.default,
                                         iconography: JSONIconography.default)
}
