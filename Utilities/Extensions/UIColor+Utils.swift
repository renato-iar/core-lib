//
//  Color+Utils.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import Foundation
import UIKit

extension UIColor {

    init(hex: Int) {

        let (r, g, b, a) = Color.rgba(fromHex: hex)
        let factor: Double = 1.0 / 255.0

        self.init(red: Double(r) * factor,
                  green: Double(g) * factor,
                  blue: Double(b) * factor,
                  opacity: Double(a) * factor)
    }

    static func rgba(fromHex hex: Int) -> (red: Int, green: Int, blue: Int, alpha: Int) {

        return (red: (hex >> 16) & 0xFF,
                green: (hex >> 8) & 0xFF,
                blue: (hex >> 0) & 0xFF,
                alpha: (hex >> 24) & 0xFF)
    }
}
