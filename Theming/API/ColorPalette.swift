//
//  ColorPalette.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 21/08/2022.
//

public protocol ColorPalette {

    associatedtype Color

    func color(for type: ColorType) -> Color
}

public extension ColorPalette {

    func color(for type: ColorType) -> Color { self.color(for: type) }

    var background: Color { self.color(for: .background) }
    var backgroundSecondary: Color { self.color(for: .backgroundSecondary) }
    var backgroundInverted: Color { self.color(for: .backgroundInverted) }
    var groupBackground: Color { self.color(for: .groupBackground) }

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

    var redacted: Color { self.color(for: .redacted) }
    var redactedLight: Color { self.color(for: .redactedLight) }
    var redactedDark: Color { self.color(for: .redactedDark) }
}
