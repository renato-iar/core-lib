import UIKit

struct PlottingContext {
    let graphicsContext: CGContext
    let transform: CGAffineTransform
    let containerFrame: CGRect
    let xAxis: ChartAxis
    let yAxis: ChartAxis
    let inset: UIEdgeInsets
    let progress: CGFloat
}

extension PlottingContext {
    func adjust(_ point: CGPoint) -> CGPoint {
        var adjusted = point
        adjusted.y = self.yAxis.origin + (point.y - self.yAxis.origin) * self.progress

        return adjusted
    }
}

protocol Plottable {
    func draw(with context: PlottingContext)
}
