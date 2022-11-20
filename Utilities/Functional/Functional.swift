import Foundation

public enum FunctionalHelpers { }

public extension FunctionalHelpers {
    static func unwrap<T>(_ value: @autoclosure () -> T?,
                          message: @autoclosure () -> String) -> T {
        guard let value = value() else {
            fatalError(message())
        }

        return value
    }

    static func unwrap<T>(_ value: @autoclosure () -> T?) -> T {
        unwrap(value(), message: "Unexpected nil value")
    }
}
