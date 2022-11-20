import Foundation
import UIKit

extension UIColor {

    public convenience init(hex: Int) {

        let (r, g, b, a) = UIColor.rgba(fromHex: hex)
        let factor: Double = 1.0 / 255.0

        self.init(red: Double(r) * factor,
                  green: Double(g) * factor,
                  blue: Double(b) * factor,
                  alpha: Double(a) * factor)
    }

    public func blend(_ percent: CGFloat, with color: UIColor) -> UIColor {
        let (r1, g1, b1, a1) = self.rgba
        let (r2, g2, b2, a2) = color.rgba

        return UIColor(red: lerp(r1, r2, percent: percent),
                       green: lerp(g1, g2, percent: percent),
                       blue: lerp(b1, b2, percent: percent),
                       alpha: lerp(a1, a2, percent: percent))
    }

    static func rgba(fromHex hex: Int) -> (red: Int, green: Int, blue: Int, alpha: Int) {

        return (red: (hex >> 16) & 0xFF,
                green: (hex >> 8) & 0xFF,
                blue: (hex >> 0) & 0xFF,
                alpha: (hex >> 24) & 0xFF)
    }
}

// MARK: - Private

private extension UIColor {
    var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r = CGFloat.zero
        var g = CGFloat.zero
        var b = CGFloat.zero
        var a = CGFloat.zero

        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        return (r, g, b, a)
    }
}

private func lerp(_ a: CGFloat, _ b: CGFloat, percent: CGFloat) -> CGFloat {
    return (a * (1 - percent)) + (b * (percent))
}
