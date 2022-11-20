import UIKit

public struct ChartAxis: Equatable {
    public let origin: CGFloat
    public let length: CGFloat

    public init(origin: CGFloat = .zero, length: CGFloat) {
        self.origin = origin
        self.length = length
    }
}

public extension ChartAxis {
    static let unit: Self = .init(origin: .zero, length: 1)
}

public extension ChartAxis {
    var center: CGFloat { self.origin + self.length * 0.5 }
    var end: CGFloat { self.origin + self.length }
}
