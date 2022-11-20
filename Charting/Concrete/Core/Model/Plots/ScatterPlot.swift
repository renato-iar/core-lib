import UIKit

public extension Plot {
    struct Scatter: Identifiable {
        public let id: Int
        public let points: [Plot.Scatter.Point]
        public let animation: Plot.Scatter.AnimationType
        public let intersectable: Bool

        public init(points: [Plot.Scatter.Point], animation: Plot.Scatter.AnimationType, intersectable: Bool = true) {
            self.id = Plot.nextSerialId
            self.points = points
            self.animation = animation
            self.intersectable = intersectable
        }
    }
}

public extension Plot.Scatter {
    enum AnimationType {
        case move
        case fadeIn
    }

    enum Shape {
        case circle(radius: CGFloat)
        case star(points: Int, outterRadius: CGFloat, innerRadius: CGFloat)
        case upTriangle(width: CGFloat, height: CGFloat)
        case downTriangle(width: CGFloat, height: CGFloat)
        case square(size: CGFloat)
    }

    struct Point {
        public let cgPoint: CGPoint
        public let x: CGFloat
        public let y: CGFloat
        public let shape: Plot.Scatter.Shape
        public let paint: [Paint]

        public init(point: CGPoint, shape: Plot.Scatter.Shape, paint: [Paint]) {
            self.cgPoint = point
            self.x = point.x
            self.y = point.y
            self.shape = shape
            self.paint = paint
        }

        public init(point: CGPoint, shape: Plot.Scatter.Shape, _ paints: Paint ...) {
            self.init(point: point, shape: shape, paint: paints)
        }

        public init(x: CGFloat, y: CGFloat, shape: Plot.Scatter.Shape, paint: [Paint]) {
            self.init(point: CGPoint(x: x, y: y), shape: shape, paint: paint)
        }

        public init(x: CGFloat, y: CGFloat, shape: Plot.Scatter.Shape, _ paints: Paint ...) {
            self.init(x: x, y: y, shape: shape, paint: paints)
        }
    }
}

// MARK: - Plottable

extension Plot.Scatter: Plottable {
    func draw(with context: PlottingContext) {
        let total = self.points.count
        self.points.enumerated().forEach { self.draw($1, at: $0, total: total, context: context) }
    }
}

// MARK: - Intersectable

extension Plot.Scatter: Intersectable {
    func intersects(point pointInViewCoordinates: CGPoint, with context: ChartView.IntersectionContext) -> Plot.Scatter.Intersection? {
        let intersections: [Plot.Scatter.Intersection.Point] = self.points.enumerated().compactMap { index, point in
            let plotPointInViewCoordinates = point.cgPoint.applying(context.transform)
            let distance = pointInViewCoordinates.vector(to: plotPointInViewCoordinates).length

            switch point.shape {
            case .circle(radius: let radius) where distance < radius,
                 .star(points: _, outterRadius: let radius, innerRadius: _) where distance < radius:
                return .init(index: index, point: point, distance: distance)

            case .upTriangle(width: let width, height: let height),
                 .downTriangle(width: let width, height: let height):
                let rect = CGRect(x: plotPointInViewCoordinates.x - width * 0.5,
                                  y: plotPointInViewCoordinates.y - height * 0.5,
                                  width: width,
                                  height: height)

                if rect.contains(pointInViewCoordinates) {
                    return .init(index: index,
                                 point: point,
                                 distance: distance)
                }

                return nil

            case .square(size: let size):
                let rect = CGRect(x: plotPointInViewCoordinates.x - size * 0.5,
                                  y: plotPointInViewCoordinates.y - size * 0.5,
                                  width: size,
                                  height: size)

                if rect.contains(pointInViewCoordinates) {
                    return .init(index: index,
                                 point: point,
                                 distance: distance)
                }

                return nil

            default:
                return nil
            }
        }

        guard intersections.isNotEmpty else { return nil }

        return .init(intersections: intersections, pointInViewCoordinates: pointInViewCoordinates)
    }

    public struct Intersection {
        public struct Point {
            public let index: Int
            public let point: Plot.Scatter.Point
            public let distance: CGFloat
        }

        public let intersections: [Plot.Scatter.Intersection.Point]
        public let pointInViewCoordinates: CGPoint
    }
}

// MARK: - Private (drawing)

private extension Plot.Scatter {
    func draw(_ point: Plot.Scatter.Point, at index: Int, total: Int, context: PlottingContext) {
        point.shape.draw(in: point.cgPoint,
                         at: index,
                         total: total,
                         paint: point.paint,
                         animation: self.animation,
                         context: context)
    }
}

// MARK: - Private (shape drawing)

private extension Plot.Scatter.Shape {
    func draw(in incomingPoint: CGPoint,
              at index: Int,
              total: Int,
              paint: [Paint],
              animation: Plot.Scatter.AnimationType,
              context: PlottingContext) {
        let point = context.adjust(incomingPoint).applying(context.transform)

        switch self {
        case let .circle(radius: radius):
            self.drawCircle(radius: radius, in: point, at: index, total: total, paint: paint, animation: animation, context: context)

        case let .star(points: points, outterRadius: outterRadius, innerRadius: innerRadius):
            self.drawStar(points: points, outterRadius: outterRadius, innerRadius: innerRadius, in: point, at: index, total: total, paint: paint, animation: animation, context: context)

        case let .upTriangle(width: width, height: height):
            self.drawUpTriangle(width: width, height: height, in: point, at: index, total: total, paint: paint, animation: animation, context: context)

        case let .downTriangle(width: width, height: height):
            self.drawDownTriangle(width: width, height: height, in: point, at: index, total: total, paint: paint, animation: animation, context: context)

        case let .square(size: size):
            self.drawSquare(size: size, in: point, at: index, total: total, paint: paint, animation: animation, context: context)
        }
    }

    // MARK: Shapes

    private func drawCircle(radius: CGFloat,
                            in point: CGPoint,
                            at index: Int,
                            total: Int,
                            paint: [Paint],
                            animation: Plot.Scatter.AnimationType,
                            context: PlottingContext) {
        let path = CGMutablePath()
        path.addEllipse(in: point.rect(radius: radius))

        paint.forEach { $0(path, with: context) }
    }

    private func drawStar(points numberOfStarPoints: Int,
                          outterRadius: CGFloat,
                          innerRadius: CGFloat,
                          in point: CGPoint,
                          at index: Int,
                          total: Int,
                          paint: [Paint],
                          animation: Plot.Scatter.AnimationType,
                          context: PlottingContext) {
        guard numberOfStarPoints > 2 else { return }

        let path = CGMutablePath()
        let delta = CGFloat.pi * 2 / CGFloat(numberOfStarPoints)
        let normalized = CGPoint(x: 0, y: 1)

        for starPointIndex in 0 ..< numberOfStarPoints {
            // NOTE: adding π orientates the tip of the star correctly upwards
            let nearDelta = CGFloat(starPointIndex) * delta + .pi
            let farDelta = nearDelta + delta * 0.5
            let farPoint = normalized.rotate(by: nearDelta).multiply(by: outterRadius).add(point)
            let nearPoint = normalized.rotate(by: farDelta).multiply(by: innerRadius).add(point)

            if starPointIndex == 0 {
                path.move(to: farPoint)
            } else {
                path.addLine(to: farPoint)
            }
            path.addLine(to: nearPoint)
        }

        paint.forEach { $0(path, with: context) }
    }

    private func drawUpTriangle(width: CGFloat,
                                height: CGFloat,
                                in point: CGPoint,
                                at index: Int,
                                total: Int,
                                paint: [Paint],
                                animation: Plot.Scatter.AnimationType,
                                context: PlottingContext) {
        let path = CGMutablePath()
        let points = [
            CGPoint(x: point.x, y: point.y - height * 0.5),
            CGPoint(x: point.x + width * 0.5, y: point.y + height * 0.5),
            CGPoint(x: point.x - width * 0.5, y: point.y + height * 0.5)
        ]

        path.addLines(between: points)
        path.closeSubpath()
        paint.forEach { $0(path, with: context) }
    }

    private func drawDownTriangle(width: CGFloat,
                                  height: CGFloat,
                                  in point: CGPoint,
                                  at index: Int,
                                  total: Int,
                                  paint: [Paint],
                                  animation: Plot.Scatter.AnimationType,
                                  context: PlottingContext) {
        let path = CGMutablePath()
        let points = [
            CGPoint(x: point.x, y: point.y + height * 0.5),
            CGPoint(x: point.x - width * 0.5, y: point.y - height * 0.5),
            CGPoint(x: point.x + width * 0.5, y: point.y - height * 0.5)
        ]

        path.addLines(between: points)
        path.closeSubpath()
        paint.forEach { $0(path, with: context) }
    }

    private func drawSquare(size: CGFloat,
                            in point: CGPoint,
                            at index: Int,
                            total: Int,
                            paint: [Paint],
                            animation: Plot.Scatter.AnimationType,
                            context: PlottingContext) {
        let path = CGMutablePath()
        let rect = point.rect(radius: size * 0.5)
        path.addRect(rect)

        paint.forEach { $0(path, with: context) }
    }
}
