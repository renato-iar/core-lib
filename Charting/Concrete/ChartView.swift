import UIKit

public final class ChartView: UIView {

    // MARK: Initializers

    private var isPerformingBatchUpdates = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.contentsScale = UIScreen.main.scale
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.contentsScale = UIScreen.main.scale
    }

    // MARK: Overrides

    public override class var layerClass: AnyClass { ChartLayer.self }

    public override var bounds: CGRect {
        get { super.bounds }
        set(rect) {
            super.bounds = rect
            self.chartLayer.recalculateChartTransform()
            self.layer.setNeedsDisplay()
        }
    }
}

// MARK: - API (updates)

public extension ChartView {
    var progress: CGFloat {
        get { self.chartLayer.progress }
        set (percent) {
            let newProgress = max(0, min(1, percent))
            if newProgress != self.progress {
                self.chartLayer.progress = newProgress
                self.setNeedsDisplayIfNotInBatchMode()
            }
        }
    }

    var plots: [Plot] {
        get { self.chartLayer.plots }
        set(plots) {
            self.chartLayer.plots = plots
            self.setNeedsDisplayIfNotInBatchMode()
        }
    }

    var xAxis: ChartAxis {
        get { self.chartLayer.xAxis }
        set(axis) {
            self.chartLayer.xAxis = axis
            self.setNeedsDisplayIfNotInBatchMode()
        }
    }

    var yAxis: ChartAxis {
        get { self.chartLayer.yAxis }
        set(axis) {
            self.chartLayer.yAxis = axis
            self.setNeedsDisplayIfNotInBatchMode()
        }
    }

    var insets: UIEdgeInsets {
        get { self.chartLayer.insets }
        set(insets) {
            self.chartLayer.insets = insets
            self.setNeedsDisplayIfNotInBatchMode()
        }
    }

    func performBatchUpdates(_ updates: () -> Void) {
        self.isPerformingBatchUpdates = true
        updates()
        self.isPerformingBatchUpdates = false

        self.setNeedsDisplayIfNotInBatchMode()
    }
}

// MARK: - API (animation)

public extension ChartView {
    func animate(duration: TimeInterval, persistent: Bool = true) {
        self.chartLayer.animate(duration: duration, persistent: persistent)
    }
}

// MARK: - API (intersection)

public extension ChartView {
    func intersect(point pointInViewCoordinates: CGPoint) -> [ChartView.Intersection] {
        let intersectionContext = ChartView.IntersectionContext(transform: self.chartLayer.chartTransform,
                                                                containerFrame: self.frame,
                                                                xAxis: self.xAxis,
                                                                yAxis: self.yAxis,
                                                                inset: self.insets,
                                                                progress: self.chartLayer.progress)
        return self.plots.compactMap { plot in
            switch plot {
            case .bar(let plot) where plot.intersectable:
                return plot.intersects(point: pointInViewCoordinates, with: intersectionContext).flatMap { .bar(result: $0) }

            case .pie(let plot) where plot.intersectable:
                return plot.intersects(point: pointInViewCoordinates, with: intersectionContext).flatMap { .pie(result: $0) }

            case .scatter(let plot) where plot.intersectable:
                return plot.intersects(point: pointInViewCoordinates, with: intersectionContext).flatMap { .scatter(result: $0) }

            case .line(let plot) where plot.intersectable:
                return plot.intersects(point: pointInViewCoordinates, with: intersectionContext).flatMap { .line(result: $0) }

            default:
                return nil
            }
        }
    }
}

// MARK: - Private (utils)

private extension ChartView {
    var chartLayer: ChartLayer { self.layer as! ChartLayer }
}

// MARK: - Private (setup)

private extension ChartView {
    private func setNeedsDisplayIfNotInBatchMode() {
        if !self.isPerformingBatchUpdates { self.layer.setNeedsDisplay() }
    }
}
