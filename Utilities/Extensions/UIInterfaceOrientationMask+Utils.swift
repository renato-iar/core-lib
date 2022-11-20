import UIKit

public extension UIInterfaceOrientationMask {
    static func | (_ lhs: UIInterfaceOrientationMask, _ rhs: UIInterfaceOrientationMask) -> UIInterfaceOrientationMask {
        UIInterfaceOrientationMask(rawValue: lhs.rawValue | rhs.rawValue)
    }
}
