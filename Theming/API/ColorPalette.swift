//
//  ColorPalette.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 21/08/2022.
//

import UIKit

public enum ColorType: String, StringRepresentable, CaseIterable {

    case background
    case backgroundSecondary
    case backgroundInverted

    case text
    case textSecondary
    case textInverted
    case textHighlighted

    case highlight

    case trendPositive
    case trendNegative
    case trendSame

    case boxGradientStart
    case boxGradientEnd
}

public protocol ColorPalette: AnyObject {

    var darkMode: Bool { get set }

    func color(for type: ColorType, darkMode: Bool) -> UIColor
}

public extension ColorPalette {

    var background: Color { self.color(for: .background) }
    var backgroundSecondary: Color { self.color(for: .backgroundSecondary) }
    var backgroundInverted: Color { self.color(for: .backgroundInverted) }

    var text: Color { self.color(for: .text) }
    var textSecondary: Color { self.color(for: .textSecondary) }
    var textInverted: Color { self.color(for: .textInverted) }
    var textHighlighted: Color { self.color(for: .textHighlighted) }

    var highlight: Color { self.color(for: .highlight) }

    var trendPositive: Color { self.color(for: .trendPositive) }
    var trendNegative: Color { self.color(for: .trendNegative) }
    var trendSame: Color { self.color(for: .trendSame) }

    var boxGradientStart: Color { self.color(for: .boxGradientStart) }
    var boxGradientEnd: Color { self.color(for: .boxGradientEnd) }

    func color(for type: ColorType) -> UIColor { self.color(for: type, darkMode: self.darkMode) }
}
