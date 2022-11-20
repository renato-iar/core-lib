import UIKit
import Utilities

public extension Plot {
    struct Line: Identifiable {
        public let id: Int
        public let points: [Point]
        public let paint: [Paint]
        public let closed: Bool
        public let smooth: Bool
        public let intersectable: Bool

        public init(points: [Point],
                    paint: [Paint],
                    closed: Bool = false,
                    smooth: Bool = true,
                    intersectable: Bool = true) {
            self.id = Plot.nextSerialId
            self.points = points
            self.paint = paint
            self.closed = closed
            self.smooth = smooth
            self.intersectable = intersectable
        }
    }
}

public extension Plot.Line {
    typealias Point = CGPoint
}

public extension Plot.Line {
    enum AnimationType {
        case horizontal
        case vertical
    }
}

// MARK: - Plottable

extension Plot.Line: Plottable {
    func draw(with context: PlottingContext) {
        let path = CGMutablePath()

        guard self.points.count > 1,
              self.paint.isNotEmpty else { return }

        if self.closed {
            self.startClosedDrawing(in: path, with: context, firstPoint: self.points[0])
        }

        if self.smooth {
            self.smoothLineDrawing(in: path, with: context, performMove: !self.closed)
        } else {
            self.straightLineDrawing(in: path, with: context, performMove: !self.closed)
        }

        if self.closed {
            self.endClosedDrawing(in: path, with: context, endPoint: self.points[self.points.count - 1])
        }

        for paint in self.paint {
            paint.paint(path, with: context)
        }
    }
}

// MARK: Intersectable

extension Plot.Line: Intersectable {
    func intersects(point pointInViewCoordinates: CGPoint, with intersectionContext: ChartView.IntersectionContext) -> Plot.Line.Intersection? {

        guard self.points.count > 1 else { return nil }

        var startIndex = 0
        var startPoint = self.points[0]
        var startPointInViewCoordinates = startPoint.applying(intersectionContext.transform)

        for endIndex in 1 ..< self.points.count {
            let endPoint = self.points[endIndex]
            let endPointInViewCoordinates = endPoint.applying(intersectionContext.transform)

            if pointInViewCoordinates.x > startPointInViewCoordinates.x,
               pointInViewCoordinates.x < endPointInViewCoordinates.x {
                let progress = (pointInViewCoordinates.x - startPointInViewCoordinates.x) / (endPointInViewCoordinates.x - startPointInViewCoordinates.x)
                return .init(startIndex: startIndex,
                             endIndex: endIndex,
                             startPoint: startPoint,
                             endPoint: endPoint,
                             startPointInViewCoordinates: startPointInViewCoordinates,
                             endPointInViewCoordinates: endPointInViewCoordinates,
                             progressPercent: progress)
            }

            startIndex = endIndex
            startPoint = endPoint
            startPointInViewCoordinates = endPointInViewCoordinates
        }

        return nil
    }

    public struct Intersection {
        public let startIndex: Int
        public let endIndex: Int
        public let startPoint: Plot.Line.Point
        public let endPoint: Plot.Line.Point
        public let startPointInViewCoordinates: CGPoint
        public let endPointInViewCoordinates: CGPoint
        public let progressPercent: CGFloat
    }
}

// MARK: - Private (drawing)

private extension Plot.Line {
    private func startClosedDrawing(in path: CGMutablePath, with context: PlottingContext, firstPoint point: Plot.Line.Point) {
        let axisPoint = Plot.Line.Point(x: point.x, y: context.yAxis.origin)
        let adjustedPoint = context.adjust(point)

        path.move(to: axisPoint, transform: context.transform)
        path.addLine(to: adjustedPoint, transform: context.transform)
    }

    private func endClosedDrawing(in path: CGMutablePath, with context: PlottingContext, endPoint point: Plot.Line.Point) {
        let axisPoint = Plot.Line.Point(x: point.x, y: context.yAxis.origin)

        path.addLine(to: axisPoint, transform: context.transform)
        path.closeSubpath()
    }

    private func straightLineDrawing(in path: CGMutablePath, with context: PlottingContext, performMove move: Bool) {
        if move {
            let adjustedPoint = context.adjust(self.points[0])
            path.move(to: adjustedPoint, transform: context.transform)
        }
        path.addLines(between: self.points.map { context.adjust($0) }, transform: context.transform)
    }

    private func smoothLineDrawing(in path: CGMutablePath, with context: PlottingContext, performMove move: Bool) {
        var leedPoint = context.adjust(self.points[0])

        if move {
            path.move(to: leedPoint, transform: context.transform)
        }

        for pointIndex in 1 ..< self.points.count {
            let currentPoint = context.adjust(self.points[pointIndex])
            let midPoint = leedPoint.x + (currentPoint.x - leedPoint.x) * 0.5
            let controlPoint1 = CGPoint(x: midPoint, y: leedPoint.y)
            let controlPoint2 = CGPoint(x: midPoint, y: currentPoint.y)

            path.addCurve(to: currentPoint, control1: controlPoint1, control2: controlPoint2, transform: context.transform)

            leedPoint = currentPoint
        }
    }
}
