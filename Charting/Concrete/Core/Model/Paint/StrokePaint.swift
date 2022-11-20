import UIKit

public extension Paint {
    struct Stroke {
        public let color: UIColor
        public let lineWidth: CGFloat
        public let lineCap: LineCap
        public let pattern: (phase: CGFloat, lengths: [CGFloat])?

        public init(color: UIColor, lineWidth: CGFloat, lineCap: LineCap = .round, pattern: (phase: CGFloat, lengths: [CGFloat])? = nil) {
            self.color = color
            self.lineWidth = lineWidth
            self.lineCap = lineCap
            self.pattern = pattern
        }
    }
}

public extension Paint.Stroke {
    enum LineCap {
        case round
        case butt
        case square

        var cgLineCap: CGLineCap {
            switch self {
            case .round: return .round
            case .butt: return .butt
            case .square: return .square
            }
        }
    }
}

extension Paint.Stroke: Paintable {
    func paint(_ path: CGPath, with context: PlottingContext) {
        context.graphicsContext.saveGState()
        context.graphicsContext.setStrokeColor(self.color.cgColor)
        context.graphicsContext.setLineWidth(self.lineWidth)
        context.graphicsContext.setLineCap(self.lineCap.cgLineCap)
        if let (phase, lengths) = self.pattern {
            context.graphicsContext.setLineDash(phase: phase, lengths: lengths)
        }
        context.graphicsContext.addPath(path)
        context.graphicsContext.strokePath()
        context.graphicsContext.restoreGState()
    }
}
