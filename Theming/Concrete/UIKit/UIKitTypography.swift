import UIKit
import Theming_API

public struct ConcreteTypography: Decodable {

    // MARK: Properties

    private var cachedFonts: [TypographyType: CachedFont] = [:]

    // MARK: Initializers

    init(with fonts: [TypographyType: CachedFont]) {
        self.cachedFonts = fonts
    }

    public init(from decoder: Decoder) throws {

        self.cachedFonts = try decoder.singleValueContainer()
                                      .decode([TypographyDescriptor].self)
                                      .reduce(into: [:]) { result, descriptor in
                                          guard let type = TypographyType(rawValue: descriptor.name) else { return }

                                          if descriptor.system {
                                              let fontWeight = CachedFontWeight(rawValue: descriptor.fontWeight) ?? .regular
                                              result[type] = .system(size: descriptor.fontSize, weight: fontWeight)
                                          } else {
                                              result[type] = .custom(name: descriptor.fontName, size: descriptor.fontSize)
                                          }
                                      }
    }
}

// MARK: - Decoding

private extension ConcreteTypography {
    struct TypographyDescriptor: Decodable {
        let name: String
        let system: Bool
        let fontName: String
        let fontWeight: String
        let fontSize: CGFloat
    }
}

// MARK: - Typography

extension ConcreteTypography: Typography {
    public func font(for type: TypographyType) -> UIFont {
        return self.cachedFonts[type]?.font ?? .systemFont(ofSize: Constants.fallbackFontSize)
    }
}

// MARK: - Types

extension ConcreteTypography {
    enum CachedFontWeight: String {
        case regular
        case medium
        case bold
        case light
        case thin

        var weight: UIFont.Weight {
            switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .bold: return .bold
            case .light: return .light
            case .thin: return .thin
            }
        }
    }

    enum CachedFont {
        case system(size: CGFloat, weight: CachedFontWeight)
        case custom(name: String, size: CGFloat)

        var font: UIFont {
            switch self {
            case let .system(size: size, weight: weight):
                return UIFont.systemFont(ofSize: size, weight: weight.weight)

            case let .custom(name: name, size: size):
                return UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
            }
        }
    }
}

// MARK: - Private (constants)

private extension ConcreteTypography {
    enum Constants {
        static let fallbackFontSize: CGFloat = 14
    }
}

// MARK: - Default

public extension ConcreteTypography {
    static let `default` = ConcreteTypography(with: [
        .body: .system(size: 16, weight: .regular),
        .bodyBold: .system(size: 16, weight: .bold),
        .title: .system(size: 24, weight: .regular),
        .largeTitle: .system(size: 48, weight: .regular),
        .largeTitleThin: .system(size: 48, weight: .thin),
        .subtitle: .system(size: 18, weight: .bold),
        .caption: .system(size: 14, weight: .bold),
        .action: .system(size: 16, weight: .bold),
        .footnote: .system(size: 12, weight: .bold)
    ])
}
