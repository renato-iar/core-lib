import Theming_API
import UIKit

public extension UIImageView {
    @discardableResult
    func redacted(color: UIColor) -> Self {
        self.image = nil
        self.backgroundColor = color

        return self
    }

    @discardableResult
    func redacted<ThemeType: UIKitTheme>(theme: ThemeType) -> Self {
        self.backgroundColor = theme.palette.color(for: .redacted)
        return self
    }
}
