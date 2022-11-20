import UIKit

public extension Paint {
    struct Fill {
        public let color: UIColor

        public init(color: UIColor) {
            self.color = color
        }
    }
}

extension Paint.Fill: Paintable {
    func paint(_ path: CGPath, with context: PlottingContext) {
        context.graphicsContext.saveGState()
        context.graphicsContext.setFillColor(self.color.cgColor)
        context.graphicsContext.addPath(path)
        context.graphicsContext.fillPath()
        context.graphicsContext.restoreGState()
    }
}
