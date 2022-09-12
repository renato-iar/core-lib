//
//  JSONTypography.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import Foundation
import SwiftUI

final class JSONTypography: Typography {

    private var fonts: [TypographyType: Font]

    var text: Font { self.resolve(typography: .text) }
    var title: Font { self.resolve(typography: .title) }
    var largeTitle: Font { self.resolve(typography: .largeTitle) }
    var subtitle: Font { self.resolve(typography: .subtitle) }
    var caption: Font { self.resolve(typography: .caption) }

    private init(text: Font,
                 title: Font,
                 largeTitle: Font,
                 subtitle: Font,
                 caption: Font) {

        self.fonts = [
            .text: text,
            .title: title,
            .largeTitle: largeTitle,
            .subtitle: subtitle,
            .caption: caption
        ]
    }

    init(from decoder: Swift.Decoder) throws {

        typealias DecodedType = [FailableDecodable<DecodableJSONFont>]

        let parsedFonts = try DecodedType.init(from: decoder)
        var fonts: [TypographyType: Font] = [:]

        for parsed in parsedFonts {

            guard let result = parsed.result,
                  let fontType = TypographyType(rawValue: result.name) else {
                continue
            }

            fonts[fontType] = result.font
        }

        self.fonts = fonts
    }
}

// MARK: - Decodable

extension JSONTypography: Decodable {

    struct DecodableJSONFont: Decodable {

        enum Weight: String, Decodable {

            case ultraLight
            case thin
            case light
            case regular
            case medium
            case semibold
            case bold
            case heavy
            case black

            var asFontWeight: Font.Weight {
                switch self {
                case .ultraLight: return .ultraLight
                case .thin: return .thin
                case .light: return .light
                case .regular: return .regular
                case .medium: return .medium
                case .semibold: return .semibold
                case .bold: return .bold
                case .heavy: return .heavy
                case .black: return .black
                }
            }
        }

        let name: String
        let system: Bool
        let fontName: String
        let fontWeight: Weight
        let fontSize: Int

        var font: Font {
            if self.system {
                return Font.system(size: CGFloat(self.fontSize), weight: self.fontWeight.asFontWeight)
            } else {
                return Font.custom(self.fontName, size: CGFloat(self.fontSize))
            }
        }
    }
}

// MARK: - Defaults

extension JSONTypography {

    static let `default`: some Typography = JSONTypography(text: .body,
                                                           title: .title,
                                                           largeTitle: .largeTitle,
                                                           subtitle: .title2,
                                                           caption: .caption)
}

// MARK: - Utils

private extension JSONTypography {

    func resolve(typography type: TypographyType) -> Font {

        guard let font = self.fonts[type] else {

            assertionFailure("Failed to retrieve a font of type \(type.rawValue)")

            return .system(.body)
        }

        return font
    }
}
