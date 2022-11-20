import Theming_API
import UIKit
import Utilities

public struct ConcreteColorPalette {

    // MARK: Properties

    private var cachedColors: [ColorType: UIColor] = [:]

    // MARK: Initializers

    init(with colors: [ColorType: (light: UIColor, dark: UIColor)]) {
        self.cachedColors = colors.reduce(into: [:]) { map, color in
            map[color.key] = UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? color.value.dark : color.value.light
            }
        }
    }

    public init(from decoder: Swift.Decoder) throws {
        let colors = try decoder.singleValueContainer().decode([ColorDescriptor].self)
        self.cachedColors = colors.reduce(into: [:]) { result, descriptor in
            if let type = ColorType(rawValue: descriptor.name) {
                let light = UIColor(hex: descriptor.light)
                let dark = descriptor.dark.flatMap(UIColor.init(hex:))

                result[type] = UIColor { traitCollection in
                    traitCollection.userInterfaceStyle == .dark ? (dark ?? light) : light
                }
            }
        }
    }
}

// MARK: - ColorPalette

extension ConcreteColorPalette: ColorPalette {
    public func color(for type: ColorType) -> UIColor {
        guard let color = self.cachedColors[type] else {
            assertionFailure("Failed to find a color of type \(type)")
            return .red
        }

        return color
    }
}

// MARK: - Decodable

extension ConcreteColorPalette: Decodable {
    struct ColorDescriptor: Decodable {
        let name: String
        let light: Int
        let dark: Int?

        private enum CodingKeys: String, CodingKey {
            case name
            case light
            case dark
        }

        enum DecodingError: Error {
            case invalidHexFormat(_ format: String)
        }

        init(from decoder: Swift.Decoder) throws {
            let container: KeyedDecodingContainer<ConcreteColorPalette.ColorDescriptor.CodingKeys> = try decoder.container(keyedBy: ConcreteColorPalette.ColorDescriptor.CodingKeys.self)

            self.name = try container.decode(String.self, forKey: .name)

            let lightString = try container.decode(String.self, forKey: .light).lowercased().replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "0X", with: "")

            guard let lightHex = Int(lightString, radix: 16) else { throw DecodingError.invalidHexFormat(lightString) }
            self.light = lightHex

            if let darkString = try? container.decode(String.self, forKey: .dark).lowercased().replacingOccurrences(of: "0x", with: "").replacingOccurrences(of: "0X", with: ""),
               let darkHex = Int(darkString, radix: 16) {
                self.dark = darkHex
            } else {
                self.dark = nil
            }
        }
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
