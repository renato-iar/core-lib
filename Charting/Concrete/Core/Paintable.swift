import UIKit

protocol Paintable {
    func paint(_ path: CGPath, with context: PlottingContext)
}
