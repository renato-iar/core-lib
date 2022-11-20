import UIKit

extension ChartView {
    struct IntersectionContext {
        let transform: CGAffineTransform
        let containerFrame: CGRect
        let xAxis: ChartAxis
        let yAxis: ChartAxis
        let inset: UIEdgeInsets
        let progress: CGFloat
    }
}
