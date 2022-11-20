import UIKit

open class ShapeView: UIView {

    // MARK: Properties

    public var provider: ShapeProvider? {
        didSet {
            self.shapeLayer?.path = provider?.path(in: self.bounds)
        }
    }

    // MARK: Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }

    // MARK: Overrides

    open override var bounds: CGRect {
        get { super.bounds }
        set {
            super.bounds = newValue
            self.shapeLayer?.path = self.provider?.path(in: self.bounds)
        }
    }

    open override class var layerClass: AnyClass { CAShapeLayer.self }
}

// MARK: - API

public extension ShapeView {
    var path: CGPath? {
        get { self.shapeLayer?.path }
        set { self.shapeLayer?.path = newValue }
    }

    var fillColor: UIColor? {
        get { self.shapeLayer?.fillColor.flatMap(UIColor.init(cgColor:)) }
        set { self.shapeLayer?.fillColor = newValue?.cgColor }
    }

    var strokeColor: UIColor? {
        get { self.shapeLayer?.strokeColor.flatMap(UIColor.init(cgColor:)) }
        set { self.shapeLayer?.strokeColor = newValue?.cgColor }
    }

    var lineWidth: CGFloat {
        get { self.shapeLayer?.lineWidth ?? .zero }
        set { self.shapeLayer?.lineWidth = newValue }
    }

    var lineCap: CAShapeLayerLineCap {
        get { self.shapeLayer?.lineCap ?? .round }
        set { self.shapeLayer?.lineCap = newValue }
    }

    var lineJoin: CAShapeLayerLineJoin {
        get { self.shapeLayer?.lineJoin ?? .round }
        set { self.shapeLayer?.lineJoin = newValue }
    }
}

// MARK: - Private

private extension ShapeView {

    var shapeLayer: CAShapeLayer? { self.layer as? CAShapeLayer }

    func setup() {
        self.layer.contentsScale = UIScreen.main.nativeScale
    }
}
