import UIKit

public extension UIButton {
    func addHandler(for event: UIControl.Event, handler: @escaping (UIAction) -> Void) {
        self.addAction(UIAction(handler: handler), for: event)
    }
}
