import UIKit

public extension Collection {
    var isNotEmpty: Bool { !self.isEmpty }
}

public extension Collection where Element: UIView {
    func translateAutoresizingMaskIntoConstraints(_ flag: Bool) {
        self.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = flag
        }
    }
}
