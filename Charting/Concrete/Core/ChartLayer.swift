import UIKit
import CoreGraphics
import Utilities

final class ChartLayer: CALayer {
    private(set) var chartTransform: CGAffineTransform = .identity

    @NSManaged
    @objc
    dynamic var progress: CGFloat

    var insets: UIEdgeInsets = .zero { didSet { self.recalculateChartTransform() } }
    var plots: [Plot] = []
    var xAxis: ChartAxis = .unit { didSet { self.recalculateChartTransform() } }
    var yAxis: ChartAxis = .unit { didSet { self.recalculateChartTransform() } }

    // MARK: Initializers

    override init() {
        super.init()

        self.progress = 1
    }

    override init(layer: Any) {
        super.init(layer: layer)

        if let layer = layer as? ChartLayer {
            self.progress = layer.progress
            self.insets = layer.insets
            self.plots = layer.plots
            self.xAxis = layer.xAxis
            self.yAxis = layer.yAxis
            self.chartTransform = layer.chartTransform
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        self.progress = 1
    }

    // MARK: Overrides

    override class func needsDisplay(forKey key: String) -> Bool {
        return key == #keyPath(progress) || super.needsDisplay(forKey: key)
    }

    override func action(forKey event: String) -> CAAction? {
        if event == #keyPath(progress) {
            let action = CABasicAnimation(keyPath: #keyPath(progress))

            action.fromValue = self.presentation()?.value(forKey: event) ?? self.progress

            return action
        } else {
            return super.action(forKey: event)
        }
    }

    override func draw(in ctx: CGContext) {
        let context = PlottingContext(graphicsContext: ctx,
                                      transform: self.chartTransform,
                                      containerFrame: self.bounds,
                                      xAxis: self.xAxis,
                                      yAxis: self.yAxis,
                                      inset: self.insets,
                                      progress: self.progress)

        for plot in self.plots {
            ctx.saveGState()
            plot.draw(with: context)
            ctx.restoreGState()
        }
    }

    override var bounds: CGRect {
        get { super.bounds }
        set(rect) {
            super.bounds = rect
            self.recalculateChartTransform()
        }
    }
}

// MARK: - View connection

extension ChartLayer {
    func recalculateChartTransform() {
        let availableHeight = self.bounds.height - self.insets.vertical
        let yScale = (self.bounds.height - self.insets.vertical) / (self.yAxis.length - self.yAxis.origin)
        let xScale = (self.bounds.width - self.insets.horizontal) / (self.xAxis.length - self.xAxis.origin)

        self.chartTransform = .identity
                              .translatedBy(x: self.insets.left, y: self.insets.top + availableHeight)
                              .scaledBy(x: xScale, y: -yScale)
    }
}

// MARK: - Animation

extension ChartLayer {
    func animate(duration: TimeInterval, persistent: Bool = true) {
        let animation = CABasicAnimation(keyPath: #keyPath(progress))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        animation.isRemovedOnCompletion = !persistent

        self.add(animation, forKey: "animationProgress")
    }
}
