import UIKit

public extension UIStackView {
    @discardableResult
    func addArranged(subviews: [UIView]) -> Self {
        subviews.forEach { self.addArrangedSubview($0) }
        return self
    }

    @discardableResult
    func addArranged(_ subviews: UIView ...) -> Self {
        return self.addArranged(subviews: subviews)
    }
}
