import UIKit

public protocol Dimensions {
    func dimension(_ type: DimensionType) -> CGFloat
}

public extension Dimensions {
    var s2: CGFloat { self.dimension(.s2) }
    var s4: CGFloat { self.dimension(.s4) }
    var s8: CGFloat { self.dimension(.s8) }
    var s12: CGFloat { self.dimension(.s12) }
    var s16: CGFloat { self.dimension(.s16) }
    var s24: CGFloat { self.dimension(.s24) }
    var s32: CGFloat { self.dimension(.s32) }
    var s48: CGFloat { self.dimension(.s48) }
}
