import UIKit

public extension ChartView {
    enum Intersection {
        case bar(result: Plot.Bar.Intersection)
        case pie(result: Plot.Pie.Intersection)
        case scatter(result: Plot.Scatter.Intersection)
        case line(result: Plot.Line.Intersection)
    }
}
