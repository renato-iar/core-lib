import Theming_API
import UIKit

public extension UILabel {
    @discardableResult
    func redactedStyle(with placeholder: String,
                       font: UIFont,
                       color: UIColor) -> Self {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .backgroundColor: color
        ]

        self.attributedText = NSAttributedString(string: placeholder, attributes: attributes)

        return self
    }

    @discardableResult
    func redactedStyle<ThemeType: UIKitTheme>(with placeholder: String,
                                              typography type: TypographyType,
                                              theme: ThemeType) -> Self {
        self.redactedStyle(with: placeholder,
                           font: theme.typography.font(for: type),
                           color: theme.palette.color(for: .redacted))
    }
}
