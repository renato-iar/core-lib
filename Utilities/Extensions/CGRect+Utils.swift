import UIKit

public extension CGRect {
    static func between(_ pointA: CGPoint, and pointB: CGPoint) -> Self {
        .init(x: min(pointA.x, pointB.x),
              y: min(pointA.y, pointB.y),
              width: abs(pointA.x - pointB.x),
              height: abs(pointA.y - pointB.y))
    }

    static func around(_ point: CGPoint, radius: CGFloat) -> Self {
        .init(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
    }

    func inset(_ insets: UIEdgeInsets) -> Self {
        var rect = self

        if insets.horizontal < self.width {
            rect.origin.x += insets.left
            rect.size.width -= insets.horizontal
        }

        if insets.vertical < self.height {
            rect.origin.y += insets.top
            rect.size.height -= insets.vertical
        }

        return rect
    }
}

public extension CGRect {
    var topLeft: CGPoint { .init(x: self.minX, y: self.minY) }
    var topCenter: CGPoint { .init(x: self.midX, y: self.minY) }
    var topRight: CGPoint { .init(x: self.maxX, y: self.minY) }

    var centerLeft: CGPoint { .init(x: self.minX, y: self.midY) }
    var center: CGPoint { .init(x: self.midX, y: self.midY) }
    var centerRight: CGPoint { .init(x: self.maxX, y: self.midY) }

    var bottomLeft: CGPoint { .init(x: self.minX, y: self.maxY) }
    var bottomCenter: CGPoint { .init(x: self.midX, y: self.maxY) }
    var bottomRight: CGPoint { .init(x: self.maxX, y: self.maxY) }
}
