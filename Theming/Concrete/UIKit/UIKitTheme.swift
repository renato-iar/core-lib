import UIKit
import Theming_API

public protocol UIKitTheme: Theme
where
ThemeGalleryType.Image: UIImage,
ThemeIconographyType.Icon: UIImage,
ThemeColorPaletteType.Color: UIColor,
ThemeTypographyType.Font: UIFont {
}

public struct ConcreteTheme: Decodable {
    public let name: String = "default"

    public let gallery: ConcreteGallery
    public let iconography: ConcreteIconography
    public let typography: ConcreteTypography
    public let palette: ConcreteColorPalette
    public let dimensions: ConcreteDimensions

    // MARK: Decodable

    init() {
        self.gallery = ConcreteGallery.default
        self.iconography = ConcreteIconography.default
        self.typography = ConcreteTypography.default
        self.palette = ConcreteColorPalette.default
        self.dimensions = ConcreteDimensions.default
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.palette = try container.decode(ConcreteColorPalette.self, forKey: .palette)
        self.typography = try container.decode(ConcreteTypography.self, forKey: .typography)

        self.gallery = .default
        self.iconography = .default
        self.dimensions = .default
    }
}

// MARK: - Decoding

private extension ConcreteTheme {
    enum CodingKeys: String, CodingKey {
        case gallery
        case iconography
        case typography
        case palette
    }
}

// MARK: - Theme

extension ConcreteTheme: UIKitTheme { }

// MARK: - Default

public extension ConcreteTheme {
    static let `default` = ConcreteTheme()
}
