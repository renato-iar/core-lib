import SwiftUI
import Theming_API
import Utilities

public struct ConcreteColorPalette {

    // MARK: Properties

    private let cachedColors: [ColorType: Color]

    // MARK: Initializers

    init(with colors: [ColorType: (light: UIColor, dark: UIColor?)]) {
        self.cachedColors = colors.reduce(into: [:]) { result, keyValue in
            result[keyValue.key] = Color(uiColor: UIColor.init { traitCollection in
                if traitCollection.userInterfaceStyle == .dark,
                   let dark = keyValue.value.dark {
                    return dark
                }

                return keyValue.value.light
            })
        }
    }

    init(withColorDescriptors colorDescriptors: [ColorDescriptor]) {
        self.init(with: colorDescriptors.reduce(into: [:]) { result, descriptor in
            if let type = ColorType(rawValue: descriptor.name) {
                let light = UIColor(hex: descriptor.light)
                let dark = descriptor.dark.flatMap(UIColor.init(hex:))

                result[type] = (light, dark)
            }
        })
    }

    public init(from decoder: Swift.Decoder) throws {
        let descriptors = try decoder.singleValueContainer().decode([ColorDescriptor].self)

        self.init(withColorDescriptors: descriptors)
    }
}

// MARK: - ColorPalette

extension ConcreteColorPalette: ColorPalette {
    public typealias Color = SwiftUI.Color

    public func color(for type: ColorType) -> Color {
        self.cachedColors[type] ?? Color(uiColor: .red)
    }
}

// MARK: - Decodable

extension ConcreteColorPalette: Decodable {
    struct ColorDescriptor: Decodable {
        let name: String
        let light: Int
        let dark: Int?
    }
}

// MARK: - Default

public extension ConcreteColorPalette {
    static let `default` = ConcreteColorPalette(with: [
        .background: (UIColor(hex: 0xFFFFFFFF), UIColor(hex: 0xFF000000)),
        .backgroundSecondary: (UIColor(hex: 0xFFD0D0D0), UIColor(hex: 0xFF0D0D0D)),
        .backgroundInverted: (UIColor(hex: 0xFF000000), UIColor(hex: 0xFFFFFFFF)),
        .groupBackground: (UIColor(hex: 0xFFF8F8F8), UIColor(hex: 0xFF080808)),
        .text: (UIColor(hex: 0xFF000000), UIColor(hex: 0xFFFFFFFF)),
        .textSecondary: (UIColor(hex: 0xFF666666), UIColor(hex: 0xFF999999)),
        .textInverted: (UIColor(hex: 0xFFFFFFFF), UIColor(hex: 0xFF000000)),
        .textHighlighted: (UIColor(hex: 0xFFFFFFFF), UIColor(hex: 0xFFFFFFFF)),
        .highlight: (UIColor(hex: 0xFF1199CC), UIColor(hex: 0xFF1199CC)),
        .trendPositive: (UIColor(hex: 0xFF11DA11), UIColor(hex: 0xFF11DA11)),
        .trendNegative: (UIColor(hex: 0xFFDA1111), UIColor(hex: 0xFFDA1111)),
        .trendSame: (UIColor(hex: 0xFFDADA11), UIColor(hex: 0xFFDADA11)),
        .boxGradientStart: (UIColor(hex: 0xFF1199CC), UIColor(hex: 0xFF1199CC)),
        .boxGradientEnd: (UIColor(hex: 0xFFB91005), UIColor(hex: 0xFFB91005)),
        .redacted: (UIColor(hex: 0xFF777777), UIColor(hex: 0xFF777777)),
        .redactedLight: (UIColor(hex: 0xFFAAAAAA), UIColor(hex: 0xFFAAAAAA)),
        .redactedDark: (UIColor(hex: 0xFF444444), UIColor(hex: 0xFF444444))
    ])
}
