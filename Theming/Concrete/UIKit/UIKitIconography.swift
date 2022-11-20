import UIKit
import Theming_API

public struct ConcreteIconography {

    // MARK: Properties

    private var cachedIcons: [IconographyType: CachedIcon] = [:]

    // MARK: Initializers

    init(with icons: [IconographyType: CachedIcon]) {
        self.cachedIcons = icons
    }
}

// MARK: - Iconography

extension ConcreteIconography: Iconography {
    public func icon(for type: IconographyType, darkMode: Bool) -> UIImage {
        if let cached = self.cachedIcons[type] {
            return cached.image(darkMode: darkMode)
        } else {
            return UIImage()
        }
    }
}

// MARK: - Types

extension ConcreteIconography {
    enum CachedIcon {
        case system(name: String, darkMode: String?)
        case bundled(name: String, darkMode: String?, bundle: Bundle?)

        func image(darkMode: Bool) -> UIImage {
            switch self {
            case let .system(name: _, darkMode: name?) where darkMode,
                 let .system(name: name, darkMode: _):
                if let image = UIImage(systemName: name) {
                    return image
                }

            case let .bundled(name: _, darkMode: name?, bundle: bundle) where darkMode,
                 let .bundled(name: name, darkMode: _, bundle: bundle):
                if let image = UIImage(named: name, in: bundle, with: nil) {
                    return image
                }
            }

            return UIImage()
        }
    }
}

// MARK: - Private (constants)

private extension ConcreteIconography {
    enum Constants {
        static let fallbackIconName = "exclamationmark.triangle.fill"
    }
}

// MARK: - Defaults

public extension ConcreteIconography {
    static let `default` = ConcreteIconography(with: [
        .arrowForward: .system(name: "arrow.forward", darkMode: nil),
        .arrowBack: .system(name: "arrow.backward", darkMode: nil),
        .trash: .system(name: "trash.fill", darkMode: nil),
        .info: .system(name: "info.circle.fill", darkMode: nil),
        .chevronForward: .system(name: "chevron.forward", darkMode: nil),
        .chevronBack: .system(name: "chevron.backward", darkMode: nil),
        .chevronUp: .system(name: "chevron.up", darkMode: nil),
        .chevronDown: .system(name: "chevron.down", darkMode: nil),
        .eye: .system(name: "eye.circle.fill", darkMode: nil),
        .eyeSlash: .system(name: "eye.slash.circle.fill", darkMode: nil),
        .more: .system(name: "ellipsis", darkMode: nil),
        .settings: .system(name: "gear", darkMode: nil),
        .menu: .system(name: "line.3.horizontal", darkMode: nil),
        .addFull: .system(name: "plus.circle.fill", darkMode: nil),
        .checkFull: .system(name: "checkmark.circle.fill", darkMode: nil),
        .add: .system(name: "plus", darkMode: nil),
        .check: .system(name: "checkmark", darkMode: nil),
        .calendar: .system(name: "calendar", darkMode: nil),
        .calendarFull: .system(name: "calendar.circle.fill", darkMode: nil),
        .deleteFull: .system(name: "delete.backward.fill", darkMode: nil),
        .avatarFull: .system(name: "person.crop.circle.fill", darkMode: nil),
        .star: .system(name: "star", darkMode: nil),
        .starFill: .system(name: "star.fill", darkMode: nil),
        .starHalfFill: .system(name: "star.leadinghalf.filled", darkMode: nil)
    ])
}
