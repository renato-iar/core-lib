import UIKit

public extension NSLayoutConstraint {
    static func activating(_ constraints: NSLayoutConstraint ...) {
        self.activate(constraints)
    }
}
