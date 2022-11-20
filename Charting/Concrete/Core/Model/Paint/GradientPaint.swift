import Foundation
import UIKit

public extension Paint {
    enum Gradient {
        case linear(startColor: UIColor, endColor: UIColor, locations: [CGFloat]?, startPoint: RefferencePoint, endPoint: RefferencePoint)
        case radial(startColor: UIColor, endColor: UIColor)

        public static func linear(start: UIColor,
                                  end: UIColor,
                                  locations: [CGFloat]? = nil,
                                  startPoint: RefferencePoint = .topLeft,
                                  endPoint: RefferencePoint = .bottomLeft) -> Self {
            .linear(startColor: start, endColor: end, locations: locations, startPoint: startPoint, endPoint: endPoint)
        }
    }
}

public extension Paint.Gradient {
    enum RefferencePoint {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
}

private extension Paint.Gradient.RefferencePoint {
    func point(relativeTo incomingFrame: CGRect?) -> CGPoint {
        let frame = incomingFrame ?? CGRect(x: 0, y: 0, width: 1, height: 1)

        switch self {
        case .topLeft: return CGPoint(x: frame.minX, y: frame.minY)
        case .topRight: return CGPoint(x: frame.maxX, y: frame.minY)
        case .bottomLeft: return CGPoint(x: frame.minX, y: frame.maxY)
        case .bottomRight: return CGPoint(x: frame.maxX, y: frame.maxY)
        }
    }
}

extension Paint.Gradient: Paintable {
    func paint(_ path: CGPath, with context: PlottingContext) {
        context.graphicsContext.saveGState()
        context.graphicsContext.addPath(path)
        context.graphicsContext.clip()

        switch self {
        case let .linear(startColor: startColor, endColor: endColor, locations: locations, startPoint: start, endPoint: end):
            self.drawLinearGradient(startColor: startColor, endColor: endColor, locations: locations, startPoint: start, endPoint: end, with: context)

        case let .radial(startColor: startColor, endColor: endColor):
            self.drawRadiaGradient(startColor: startColor, endColor: endColor, with: context)
        }

        context.graphicsContext.restoreGState()
    }
}

// MARK: - Private (drawing)

private extension Paint.Gradient {
    var gradient: CGGradient? {
        switch self {
        case let .linear(startColor: startColor, endColor: endColor, locations: _, startPoint: _, endPoint: _),
             let .radial(startColor: startColor, endColor: endColor):
            var startR = CGFloat.zero, startG = CGFloat.zero, startB = CGFloat.zero, startA = CGFloat.zero
            var endR = CGFloat.zero, endG = CGFloat.zero, endB = CGFloat.zero, endA = CGFloat.zero

            startColor.getRed(&startR, green: &startG, blue: &startB, alpha: &startA)
            endColor.getRed(&endR, green: &endG, blue: &endB, alpha: &endA)

            var colors = [startR, startG, startB, startA, endR, endG, endB, endA]
            var locations: [CGFloat] = [0.0, 1.0]
            let colorSpace = CGColorSpaceCreateDeviceRGB()

            return CGGradient(colorSpace: colorSpace,
                              colorComponents: &colors,
                              locations: &locations,
                              count: 2)
        }
    }

    func drawLinearGradient(startColor: UIColor, endColor: UIColor, locations: [CGFloat]?, startPoint: RefferencePoint, endPoint: RefferencePoint, with context: PlottingContext) {
        guard let gradient = self.gradient else { return }

        let start = startPoint.point(relativeTo: context.containerFrame)
        let end = endPoint.point(relativeTo: context.containerFrame)

        context.graphicsContext.drawLinearGradient(gradient,
                                                   start: start,
                                                   end: end,
                                                   options: .drawsBeforeStartLocation)
    }

    func drawRadiaGradient(startColor: UIColor, endColor: UIColor, with context: PlottingContext) {
        guard let gradient = self.gradient else { return }

        let horizontalInset = context.inset.horizontal
        let verticalInset = context.inset.vertical
        let width = context.containerFrame.width - horizontalInset
        let height = context.containerFrame.height - verticalInset
        let radius = min(width, height) * 0.5
        let centerX = context.inset.left + width * 0.5
        let centerY = context.inset.top + height * 0.5
        let center = CGPoint(x: centerX, y: centerY)

        context.graphicsContext.drawRadialGradient(gradient,
                                                   startCenter: center,
                                                   startRadius: .zero,
                                                   endCenter: center,
                                                   endRadius: radius,
                                                   options: .drawsBeforeStartLocation)
    }
}
