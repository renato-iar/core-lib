import UIKit

public extension CGPoint {
    /**
     Rotates the point around the origin
     This method should only be called on points that were treated as a vector and "normalized"
     */
    func rotate(by delta: CGFloat) -> Self {
        let deltaCos = cos(delta)
        let deltaSin = sin(delta)

        return .init(x: self.x * deltaCos - self.y * deltaSin, y: y * deltaCos + x * deltaSin)
    }

    func multiply(by k: CGFloat) -> Self {
        .init(x: self.x * k, y: self.y * k)
    }

    var length: CGFloat {
        return sqrt(self.x*self.x + self.y*self.y)
    }

    var normalized: Self {
        self.multiply(by: 1.0 / self.length)
    }

    func add(_ point: CGPoint) -> CGPoint {
        .init(x: self.x + point.x, y: self.y + point.y)
    }

    func sub(_ point: CGPoint) -> CGPoint {
        .init(x: self.x - point.x, y: self.y - point.y)
    }
}
