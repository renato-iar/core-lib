public protocol Iconography {
    associatedtype Icon

    func icon(for type: IconographyType, darkMode: Bool) -> Icon
}

public extension Iconography {
    func icon(for type: IconographyType) -> Icon { self.icon(for: type, darkMode: false) }
}
