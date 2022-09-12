//
//  Gallery.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import SwiftUI

public enum GalleryType: String {
    case landingWelcomeBackground = "Landing-01"
    case landingStartAuthBackground = "Landing-02"
}

public protocol Gallery {

    func image(for type: GalleryType) -> Image
}

public extension Gallery {

    var landingWelcomeBackground: Image { self.image(for: .landingWelcomeBackground) }
    var landingStartAuthBackground: Image { self.image(for: .landingStartAuthBackground) }
}
