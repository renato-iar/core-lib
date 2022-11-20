import UIKit

public enum PlotUnit {
    case relative(_ percent: CGFloat)
    case absolute(_ points: CGFloat)
}

public extension PlotUnit {
    static let zero: Self = .absolute(.zero)
}

public extension PlotUnit {
    func value(relativeTo reference: CGFloat) -> CGFloat {
        switch self {
        case .relative(let percent):
            return reference * percent

        case .absolute(let points):
            return points
        }
    }
}
