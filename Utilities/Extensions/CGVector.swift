import Foundation

public extension CGVector {
    func dot(_ other: CGVector) -> CGFloat {
        let xx = other.dx * self.dx
        let yy = other.dy * self.dy

        return xx + yy
    }

    var length: CGFloat { sqrt(self.dot(self)) }

    var normalized: CGVector {
        let length = self.length

        guard length != .zero else { return .zero }

        return CGVector(dx: self.dx / length, dy: self.dy / length)
    }

    var cgPoint: CGPoint { CGPoint(x: self.dx, y: self.dy) }
}
