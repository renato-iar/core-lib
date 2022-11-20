import UIKit

public extension Plot {
    struct Pie: Identifiable {
        private let total: CGFloat

        public let id: Int
        public let animationType: Plot.Pie.AnimationType
        public let segments: [Plot.Pie.Segment]
        public let intersectable: Bool

        public init(segments: [Plot.Pie.Segment], animation: Plot.Pie.AnimationType, intersectable: Bool = true) {
            self.id = Plot.nextSerialId
            self.animationType = animation
            self.segments = segments
            self.intersectable = intersectable
            self.total = segments.reduce(.zero) { $0 + $1.value }
        }
    }
}

public extension Plot.Pie {
    struct Segment {
        public let value: CGFloat
        public let paint: [Paint]
        public let hole: PlotUnit

        public init(value: CGFloat, paint: [Paint], hole: PlotUnit = .zero) {
            self.value = value
            self.paint = paint
            self.hole = hole
        }
    }

    enum AnimationType {
        case individual
        case cummulative
    }
}

// MARK: - Plottable

extension Plot.Pie: Plottable {
    func draw(with context: PlottingContext) {
        let center = CGPoint(x: context.xAxis.center, y: context.yAxis.center).applying(context.transform)
        let minPoint = CGPoint(x: context.xAxis.origin, y: context.yAxis.origin).applying(context.transform)
        let maxPoint = CGPoint(x: context.xAxis.end, y: context.yAxis.end).applying(context.transform)
        let radius = abs(min(maxPoint.x - minPoint.x, maxPoint.y - minPoint.y) * 0.5)

        var angle: CGFloat = .zero

        for segment in self.segments {
            context.graphicsContext.saveGState()
            angle = self.draw(segment: segment, center: center, angle: angle, radius: radius, with: context)
            context.graphicsContext.restoreGState()
        }
    }
}

// MARK: - Intersectable

extension Plot.Pie: Intersectable {
    func intersects(point pointInViewCoordinates: CGPoint,
                    with context: ChartView.IntersectionContext) -> Plot.Pie.Intersection? {
        let center = CGPoint(x: context.xAxis.center, y: context.yAxis.center).applying(context.transform)
        let minPoint = CGPoint(x: context.xAxis.origin, y: context.yAxis.origin).applying(context.transform)
        let maxPoint = CGPoint(x: context.xAxis.end, y: context.yAxis.end).applying(context.transform)
        let radius = abs(min(maxPoint.x - minPoint.x, maxPoint.y - minPoint.y) * 0.5)
        let vectorToCenter = center.vector(to: pointInViewCoordinates)
        let distanceFromCenter = vectorToCenter.length
        let normalizedVectorToCenter = vectorToCenter.normalized
        var angleToPoint = atan2(normalizedVectorToCenter.dy, normalizedVectorToCenter.dx)
        if angleToPoint < .zero {
            angleToPoint += .pi * 2.0
        }

        var angle = CGFloat.zero

        for (index, segment) in self.segments.lazy.enumerated() {
            let delta = (segment.value / self.total) * CGFloat.pi * 2.0

            if angleToPoint >= angle && angleToPoint < angle + delta {
                let hole = segment.hole.value(relativeTo: radius)

                guard distanceFromCenter >= hole && distanceFromCenter <= radius else {
                    return nil
                }

                let pointInPlotCoordinates = pointInViewCoordinates.applying(context.transform.inverted())

                return Plot.Pie.Intersection(plotId: self.id,
                                             index: index,
                                             pointInPlotCoordinates: pointInPlotCoordinates,
                                             pointInViewCoordinates: pointInViewCoordinates,
                                             segment: segment)

            }

            angle += delta
        }

        return nil
    }

    public struct Intersection {
        public let plotId: Plot.Pie.ID
        public let index: Int
        public let pointInPlotCoordinates: CGPoint
        public let pointInViewCoordinates: CGPoint
        public let segment: Plot.Pie.Segment

        init(plotId: Plot.Pie.ID,
             index: Int,
             pointInPlotCoordinates: CGPoint,
             pointInViewCoordinates: CGPoint,
             segment: Plot.Pie.Segment) {
            self.plotId = plotId
            self.index = index
            self.pointInPlotCoordinates = pointInPlotCoordinates
            self.pointInViewCoordinates = pointInViewCoordinates
            self.segment = segment
        }
    }
}

// MARK: - Private (drawing)

private extension Plot.Pie {
    func draw(segment: Plot.Pie.Segment, center: CGPoint, angle: CGFloat, radius: CGFloat, with context: PlottingContext) -> CGFloat {
        let baseDelta = (segment.value / self.total) * .pi * 2
        let delta = baseDelta * context.progress
        let path = CGMutablePath()

        if case let .relative(percent) = segment.hole, percent > .zero && percent < 1 {
            path.addArc(center: center, radius: radius * percent, startAngle: angle, endAngle: angle + delta, clockwise: false)
            path.addArc(center: center, radius: radius, startAngle: angle + delta, endAngle: angle, clockwise: true)
        } else if case let .absolute(points) = segment.hole, points > .zero, points < radius {
            path.addArc(center: center, radius: points, startAngle: angle, endAngle: angle + delta, clockwise: false)
            path.addArc(center: center, radius: radius, startAngle: angle + delta, endAngle: angle, clockwise: true)
        } else {
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: angle, endAngle: angle + delta, clockwise: false)

        }

        path.closeSubpath()

        for paint in segment.paint {
            paint.paint(path, with: context)
        }

        switch self.animationType {
        case .individual:
            return angle + baseDelta
        case .cummulative:
            return angle + delta
        }
    }
}
