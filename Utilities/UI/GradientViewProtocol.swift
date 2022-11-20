import UIKit

public protocol GradientViewProtocol: AnyObject {
    var gradientType: CAGradientLayerType { get set }
    var gradientColors: [UIColor]? { get set }
    var startPoint: CGPoint { get set }
    var endPoint: CGPoint { get set }
    var locations: [CGFloat]? { get set }

    func clearGradient()
}
