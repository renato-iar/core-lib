import Foundation

public extension CGPoint {
    func rect(to point: CGPoint) -> CGRect {
        CGRect.between(self, and: point)
    }

    func rect(radius: CGFloat) -> CGRect {
        .around(self, radius: radius)
    }

    func angle(to point: CGPoint) -> CGFloat {
        let normalizedVectorToPoint = self.vector(to: point).normalized
        let theta = atan2(normalizedVectorToPoint.dy, normalizedVectorToPoint.dx)

        return theta
    }
}

public extension CGPoint {
    func vector(to other: CGPoint) -> CGVector {
        CGVector(dx: other.x - self.x, dy: other.y - self.y)
    }

    var cgVector: CGVector { CGVector(dx: self.x, dy: self.y) }
}
