import UIKit

public protocol ShapeProvider {
    func path(in rect: CGRect) -> CGPath
}
