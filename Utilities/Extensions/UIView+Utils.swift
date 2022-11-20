import UIKit

public extension UIView {
    @discardableResult
    func add(subviews: [UIView]) -> Self {
        for subview in subviews {
            self.addSubview(subview)
        }

        return self
    }

    @discardableResult
    func addSubviews(_ subviews: UIView ...) -> Self {
        return self.add(subviews: subviews)
    }

    var forAutoLayout: Self {
        self.translatesAutoresizingMaskIntoConstraints = false

        return self
    }

    static var forAutoLayout: Self { Self.init().forAutoLayout }
}

public extension UIView {
    func pin(to constrainable: Constrainable) {
        self.topAnchor.constraint(equalTo: constrainable.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: constrainable.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: constrainable.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: constrainable.trailingAnchor).isActive = true
    }

    func pinToSafeArea(of view: UIView) {
        self.pin(to: view.safeAreaLayoutGuide)
    }
}
