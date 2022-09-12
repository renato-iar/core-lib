//
//  JSONPalette.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import UIKit

final class JSONPalette: ColorPalette, Decodable {

    typealias ColorPair = (light: Color, dark: Color?)

    private var colors: [ColorType: JSONColor] = [:]

    var darkMode: Bool = false

    func color(for type: ColorType, darkMode: Bool) -> UIColor {

        guard let color = self.colors[type] else {
            assertionFailure("Failed to retrieve color <\(type.rawValue)>")

            return .purple
        }

        return self.resolve(from: color, darkMode: darkMode)
    }

    private func resolve(from color: JSONColor, darkMode: Bool) -> UIColor {
        darkMode ? (color.dark ?? color.light) : color.light
    }
    private func resolve(from color: JSONColor) -> UIColor {
        self.resolve(from: color, darkMode: self.darkMode)
    }

    private init(backgroundColor: JSONColor,
                 backgroundSecondaryColor: JSONColor,
                 backgroundInvertedColor: JSONColor,
                 textColor: JSONColor,
                 textSecondaryColor: JSONColor,
                 textInvertedColor: JSONColor,
                 textHighlightedColor: JSONColor,
                 highlightColor: JSONColor,
                 trendPositiveColor: JSONColor,
                 trendNegativeColor: JSONColor,
                 trendSameColor: JSONColor,
                 boxGradientStart: JSONColor,
                 boxGradientEnd: JSONColor,
                 darkMode: Bool = false) {

        self.colors = [
            .background: backgroundColor,
            .backgroundSecondary: backgroundSecondaryColor,
            .backgroundInverted: backgroundInvertedColor,
            .text: textColor,
            .textSecondary: textSecondaryColor,
            .textInverted: textInvertedColor,
            .textHighlighted: textHighlightedColor,
            .highlight: highlightColor,
            .trendPositive: trendPositiveColor,
            .trendNegative: trendNegativeColor,
            .trendSame: trendSameColor,
            .boxGradientStart: boxGradientStart,
            .boxGradientEnd: boxGradientEnd
        ]
        self.darkMode = darkMode
    }

    static let `default`: some ColorPalette = JSONPalette(backgroundColor: JSONColor(light: .white, dark: .black),
                                                          backgroundSecondaryColor: JSONColor(light: Color(white: 0.8), dark: Color(white: 0.2)),
                                                          backgroundInvertedColor: JSONColor(light: Color(white: 0.1), dark: Color(white: 0.9)),
                                                          textColor: JSONColor(light: .black, dark: .white),
                                                          textSecondaryColor: JSONColor(light: Color(white: 0.45), dark: .white),
                                                          textInvertedColor: JSONColor(light: .white, dark: .black),
                                                          textHighlightedColor: JSONColor(light: .white),
                                                          highlightColor: JSONColor(light: .red),
                                                          trendPositiveColor: JSONColor(light: .green),
                                                          trendNegativeColor: JSONColor(light: .red),
                                                          trendSameColor: JSONColor(light: .yellow),
                                                          boxGradientStart: JSONColor(light: .blue),
                                                          boxGradientEnd: JSONColor(light: .red))

    // MARK: Decodable

    private struct JSONColor {
        let light: UIColor
        let dark: UIColor?

        init(light: UIColor,
             dark: UIColor? = nil) {
            self.light = light
            self.dark = dark
        }
    }

    private struct DecodableJSONColor: Decodable {

        let name: String
        let light: Int
        let dark: Int?

        var lightColor: Color { fatalError() }
        var darkColor: Color? { fatalError() }
    }

    init(from decoder: Swift.Decoder) throws {

        typealias DecodedColorsArray = [FailableDecodable<DecodableJSONColor>]

        let colorsArray = try DecodedColorsArray(from: decoder)
        var colorsDictionary: [ColorType: JSONColor] = [:]

        for result in colorsArray {

            guard let color = result.result,
                  let colorType = ColorType(rawValue: color.name) else {
                continue
            }

            colorsDictionary[colorType] = JSONColor(light: color.lightColor, dark: color.darkColor)
        }

        self.colors = colorsDictionary
    }
}
