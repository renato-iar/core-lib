import Foundation
import Theming_API

public struct ConcreteDimensions: Dimensions {
    public func dimension(_ type: DimensionType) -> CGFloat {
        switch type {
        case .s2: return 2
        case .s4: return 4
        case .s8: return 8
        case .s12: return 12
        case .s16: return 16
        case .s24: return 24
        case .s32: return 32
        case .s48: return 48
        }
    }
}

// MARK: - Default

public extension ConcreteDimensions {
    static let `default`: Self = .init()
}
