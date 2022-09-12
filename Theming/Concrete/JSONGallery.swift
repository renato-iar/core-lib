//
//  JSONGallery.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Foundation
import SwiftUI

final class JSONGallery {

    // MARK: Initializers
}

// MARK: - Default

extension JSONGallery {
}

// MARK: - Gallery

extension JSONGallery: Gallery {

    func image(for type: GalleryType) -> Image { Image(type.rawValue) }
}
