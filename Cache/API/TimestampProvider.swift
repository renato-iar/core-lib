import Foundation

public protocol TimestampProvider {
    func current() -> TimeInterval
}
