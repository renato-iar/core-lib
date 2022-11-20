import UIKit

public enum Paint {
    case fill(Paint.Fill)
    case stroke(Paint.Stroke)
    case gradient(Paint.Gradient)
}

extension Paint: Paintable {
    func paint(_ path: CGPath, with context: PlottingContext) {
        switch self {
        case .fill(let paint as Paintable),
                .stroke(let paint as Paintable),
                .gradient(let paint as Paintable):
            paint.paint(path, with: context)
        }
    }

    func callAsFunction(_ path: CGPath, with context: PlottingContext) {
        self.paint(path, with: context)
    }
}
