import UIKit

public enum Either<A, B> {
    case left(A)
    case right(B)
}

public extension Either {
    func map<FA, FB>(left: (A) -> FA, right: (B) -> FB) -> Either<FA, FB> {
        switch self {
        case .left(let a): return .left(left(a))
        case .right(let b): return .right(right(b))
        }
    }

    @discardableResult
    func fmap<T>(left: (A) -> T, right: (B) -> T) -> T {
        switch self {
        case .left(let a): return left(a)
        case .right(let b): return right(b)
        }
    }
}
