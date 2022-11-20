public enum Plot {
    case line(Plot.Line)
    case scatter(Plot.Scatter)
    case bar(Plot.Bar)
    case pie(Plot.Pie)
}

extension Plot: Plottable {
    func draw(with context: PlottingContext) {
        switch self {
        case .line(let plottable as Plottable),
             .scatter(let plottable as Plottable),
             .bar(let plottable as Plottable),
             .pie(let plottable as Plottable):
            plottable.draw(with: context)
        }
    }
}

extension Plot {
    private static var serialId = 0

    static var nextSerialId: Int {
        self.serialId += 1

        return self.serialId
    }
}
