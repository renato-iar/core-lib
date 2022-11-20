import UIKit

public final class GradientView: UIView {

    // MARK: Initializers

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    // MARK: Overrides

    public override class var layerClass: AnyClass { CAGradientLayer.self }
}

// MARK: - API

extension GradientView: GradientViewProtocol {

    public var gradientType: CAGradientLayerType {
        get { self.gradientLayer?.type ?? .axial }
        set { self.gradientLayer?.type = newValue }
    }

    public var gradientColors: [UIColor]? {
        get { (self.gradientLayer?.colors as? [CGColor])?.map(UIColor.init(cgColor:)) }
        set(colors) { self.gradientLayer?.colors = colors?.map { $0.cgColor } }
    }

    public var startPoint: CGPoint {
        get { self.gradientLayer?.startPoint ?? .zero }
        set { self.gradientLayer?.startPoint = newValue }
    }

    public var endPoint: CGPoint {
        get { self.gradientLayer?.endPoint ?? .zero }
        set { self.gradientLayer?.endPoint = newValue }
    }

    public var locations: [CGFloat]? {
        get { self.gradientLayer?.locations?.map { CGFloat($0.floatValue) } ?? [] }
        set { self.gradientLayer?.locations = newValue?.map { NSNumber(floatLiteral: Double($0)) } }
    }

    public func clearGradient() {
        self.gradientColors = nil
        self.locations = nil
    }
}

// MARK: - Private

private extension GradientView {
    var gradientLayer: CAGradientLayer? { self.layer as? CAGradientLayer }

    func setup() {
        self.gradientLayer?.contentsScale = UIScreen.main.nativeScale
    }
}
