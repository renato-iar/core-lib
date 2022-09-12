//
//  Iconography.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 22/08/2022.
//

import SwiftUI

public enum IconographyType {

    case trash
}

public protocol ImageConvertible {

    func image() -> Image
}

public protocol Iconography {

    func icon(for type: IconographyType, darkMode: Bool) -> Image
}

public extension Iconography {

    func icon(for type: IconographyType) -> Image { self.icon(for: type, darkMode: false) }
}
