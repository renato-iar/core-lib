//
//  Theme.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import SwiftUI

public protocol Theme {

    associatedtype ThemeColorPaletteType: ColorPalette
    associatedtype ThemeTypographyType: Typography
    associatedtype ThemeIconographyType: Iconography
    associatedtype ThemeGalleryType: Gallery
    associatedtype ThemeDimensionsType: Dimensions

    var name: String { get }

    var palette: ThemeColorPaletteType { get }
    var typography: ThemeTypographyType { get }
    var iconography: ThemeIconographyType { get }
    var gallery: ThemeGalleryType { get }
    var dimensions: ThemeDimensionsType { get }
}
