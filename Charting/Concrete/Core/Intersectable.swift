import Foundation

protocol Intersectable {
    associatedtype IntersectionResult

    func intersects(point pointInViewCoordinates: CGPoint,
                    with context: ChartView.IntersectionContext) -> IntersectionResult
}
