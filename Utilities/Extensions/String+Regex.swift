import Foundation

public extension String {
    var isValidEmail: Bool { self.validateEmail(with: StringConstants.emailPattern)?.isEmpty == false }
}

extension String {
    /// Exposed for unit tests
    func validateEmail(with pattern: String) -> Range<Index>? {
        self.range(of: pattern, options: .regularExpression)
    }

    /// Exposed for unit tests
    func validateEmail() -> Range<Index>? {
        self.validateEmail(with: StringConstants.emailPattern)
    }
}

private enum StringConstants {
    static let emailPattern = #"^\S+([\._-]\S+)*\@\S+\.\S+"#
}
