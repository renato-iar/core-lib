import UIKit

public extension UITraitCollection {
    var isTall: Bool { self.horizontalSizeClass == .compact }
    var isWide: Bool { self.horizontalSizeClass == .regular && self.verticalSizeClass == .regular }
}
