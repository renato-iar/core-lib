import SwiftUI

public extension Path {
    mutating func move(x: CGFloat, y: CGFloat) {
        self.move(to: .init(x: x, y: y))
    }

    mutating func addLine(to x: CGFloat, y: CGFloat) {
        self.addLine(to: .init(x: x, y: y))
    }

    mutating func addLines(to points: CGPoint ...) {
        self.addLines(points)
    }

    mutating func addQuadCurve(to x: CGFloat, y: CGFloat, controlX cx: CGFloat, contryY cy: CGFloat) {
        self.addQuadCurve(to: .init(x: x, y: y), control: .init(x: cx, y: cy))
    }

    mutating func addRelativeArc(centerX cx: CGFloat, cy: CGFloat, radius: CGFloat, startAngle start: Angle, delta: Angle) {
        self.addRelativeArc(center: .init(x: cx, y: cy), radius: radius, startAngle: start, delta: delta)
    }
}
