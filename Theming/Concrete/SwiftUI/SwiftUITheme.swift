import SwiftUI
import Theming_API

public protocol SwiftUITheme: Theme
where
ThemeGalleryType.Image == Image,
ThemeIconographyType.Icon == Image,
ThemeColorPaletteType.Color == Color,
ThemeTypographyType.Font == Font {
}

public struct ConcreteTheme {

    public let name: String

    public let palette: ConcreteColorPalette
    public let typography: ConcreteTypography
    public let iconography: ConcreteIconography
    public let gallery: ConcreteGallery
    public let dimensions: ConcreteDimensions

    // MARK: Initializers

    init(name: String,
         palette: ThemeColorPaletteType,
         typography: ThemeTypographyType,
         iconography: ThemeIconographyType,
         gallery: ThemeGalleryType,
         dimensions: ThemeDimensionsType) {
        self.name = name
        self.palette = palette
        self.typography = typography
        self.iconography = iconography
        self.gallery = gallery
        self.dimensions = dimensions
    }
}

// MARK: - Theme

extension ConcreteTheme: SwiftUITheme { }

// MARK: - Default

public extension ConcreteTheme {
    static let `default`: Self = .init(name: "default",
                                       palette: .default,
                                       typography: .default,
                                       iconography: .default,
                                       gallery: .default,
                                       dimensions: .default)
}
