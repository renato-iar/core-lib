import CoreGraphics
import UIKit
import Utilities

public extension Plot {
    struct Bar: Identifiable {
        public let id: Int
        public let segments: [Bar.Segment]
        public let intersectable: Bool

        public init(segments: [Bar.Segment], intersectable: Bool = true) {
            self.id = Plot.nextSerialId
            self.segments = segments
            self.intersectable = intersectable
        }
    }
}

// MARK: - BarPlot segments

public extension Plot.Bar {
    struct Segment {
        let animationProgressPercent: CGFloat

        public let x: CGFloat
        public let width: CGFloat
        public let startY: CGFloat?
        public let value: CGFloat
        public let paint: [Paint]
        public let insets: UIEdgeInsets
        public let cornerRadius: PlotUnit

        init(animationProgressPercent progress: CGFloat,
             x: CGFloat,
             width: CGFloat = 1,
             startY: CGFloat? = nil,
             value: CGFloat,
             paint: [Paint],
             insets: UIEdgeInsets = .zero,
             cornerRadius: PlotUnit = .zero) {
            self.animationProgressPercent = progress
            self.x = x
            self.width = width
            self.startY = startY
            self.value = value
            self.paint = paint
            self.insets = insets
            self.cornerRadius = cornerRadius
        }

        public init(x: CGFloat,
                    width: CGFloat = 1,
                    startY: CGFloat? = nil,
                    value: CGFloat,
                    paint: [Paint],
                    insets: UIEdgeInsets = .zero,
                    cornerRadius: PlotUnit = .zero) {
            self.init(animationProgressPercent: 1,
                      x: x,
                      width: width,
                      startY: startY,
                      value: value,
                      paint: paint,
                      insets: insets,
                      cornerRadius: cornerRadius)
        }
    }
}

// MARK: - Plottable

extension Plot.Bar: Plottable {
    func draw(with context: PlottingContext) {
        self.segments.enumerated().forEach { self.draw(segment: $1, at: $0, with: context) }
    }
}

// MARK: - Intersectable

extension Plot.Bar: Intersectable {
    func intersects(point pointInViewCoordinates: CGPoint,
                    with context: ChartView.IntersectionContext) -> Plot.Bar.Intersection? {
        let pointInPlotCoordinates = pointInViewCoordinates.applying(context.transform.inverted())
        let segments: [(Int, Plot.Bar.Segment)] = self.segments.enumerated().compactMap { index, segment in
            guard self.rect(for: segment,
                            xAxis: context.xAxis,
                            yAxis: context.yAxis,
                            transform: context.transform,
                            progress: context.progress).contains(pointInViewCoordinates) else {
                return nil
            }

            return (index, segment)
        }

        guard segments.isNotEmpty else { return nil }

        return Intersection(plotId: self.id,
                            pointInPlotCoordinates: pointInPlotCoordinates,
                            pointInViewCoordinates: pointInViewCoordinates,
                            intersectedSegments: segments)
    }

    public struct Intersection {
        public let plotId: Plot.Bar.ID
        public let pointInPlotCoordinates: CGPoint
        public let pointInViewCoordinates: CGPoint
        public let intersectedSegments: [(index: Int, segment: Plot.Bar.Segment)]

        init(plotId id: Plot.Bar.ID,
             pointInPlotCoordinates: CGPoint,
             pointInViewCoordinates: CGPoint,
             intersectedSegments: [(index: Int, segment: Plot.Bar.Segment)]) {
            self.plotId = id
            self.pointInPlotCoordinates = pointInPlotCoordinates
            self.pointInViewCoordinates = pointInViewCoordinates
            self.intersectedSegments = intersectedSegments
        }
    }
}

// MARK: - Private (drawing)

private extension Plot.Bar {
    func rect(for segment: Plot.Bar.Segment,
              xAxis: ChartAxis,
              yAxis: ChartAxis,
              transform: CGAffineTransform,
              progress: CGFloat) -> CGRect {
        let bottomY: CGFloat

        if let y = segment.startY, y < segment.value {
            bottomY = y
        } else {
            bottomY = yAxis.origin
        }

        let distance = (segment.value - bottomY) * progress
        let topY = bottomY + distance

        let bottomLeft = CGPoint(x: segment.x, y: bottomY).applying(transform)
        let topRight = CGPoint(x: segment.x + segment.width, y: topY).applying(transform)

        return bottomLeft.rect(to: topRight).inset(segment.insets)
    }

    func draw(segment: Plot.Bar.Segment, at index: Int, with context: PlottingContext) {
        let rect = self.rect(for: segment,
                             xAxis: context.xAxis,
                             yAxis: context.yAxis,
                             transform: context.transform,
                             progress: context.progress)
        let cornerWidth = min(rect.width * 0.5, segment.cornerRadius.value(relativeTo: rect.width * 0.5))
        let cornerHeight = min(cornerWidth, rect.height * 0.5)

        let path = CGMutablePath()
        path.addRoundedRect(in: rect,
                            cornerWidth: cornerWidth,
                            cornerHeight: cornerHeight)

        for paint in segment.paint {
            paint(path, with: context)
        }
    }
}
