import UIKit

public extension UIEdgeInsets {
    var horizontal: CGFloat { self.left + self.right }
    var vertical: CGFloat { self.top + self.bottom }

    static func horizontal(_ inset: CGFloat) -> Self {
        .init(top: .zero, left: inset, bottom: .zero, right: inset)
    }

    static func vertical(_ inset: CGFloat) -> Self {
        .init(top: inset, left: .zero, bottom: inset, right: .zero)
    }

    static func top(_ inset: CGFloat) -> Self {
        .init(top: inset, left: .zero, bottom: .zero, right: .zero)
    }

    static func bottom(_ inset: CGFloat) -> Self {
        .init(top: .zero, left: .zero, bottom: inset, right: .zero)
    }

    static func left(_ inset: CGFloat) -> Self {
        .init(top: .zero, left: inset, bottom: .zero, right: .zero)
    }

    static func right(_ inset: CGFloat) -> Self {
        .init(top: .zero, left: .zero, bottom: .zero, right: inset)
    }
}
