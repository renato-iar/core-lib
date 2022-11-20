import SwiftUI
import Theming_API

public struct ConcreteTypography {

    // MARK: Properties

    private var cachedFonts: [TypographyType: CachedFont] = [:]

    // MARK: Initializers

    init(with fonts: [TypographyType: CachedFont]) {
        self.cachedFonts = fonts
    }
}

// MARK: - Typography

extension ConcreteTypography: Typography {
    public func font(for type: TypographyType) -> SwiftUI.Font {
        return self.cachedFonts[type]?.font ?? .system(size: Constants.fallbackFontSize)
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

        var weight: SwiftUI.Font.Weight {
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

        var font: Font {
            switch self {
            case let .system(size: size, weight: weight):
                return .system(size: size, weight: weight.weight)

            case let .custom(name: name, size: size):
                return .custom(name, size: size)
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
