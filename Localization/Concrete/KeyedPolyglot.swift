import Foundation
import Localization_API

public struct KeyedPolyglot<KeyType> where KeyType: Hashable, KeyType: CaseIterable, KeyType: RawRepresentable, KeyType.RawValue == String {

    private let translations: [KeyType: String]

    public func label(forKey key: KeyType) -> String { self.translations[key] ?? key.rawValue }

    private init(with translations: [KeyType: String]) {
        self.translations = translations
    }

    public init<PolyglotType: Polyglot>(polyglot: PolyglotType) {
        self.translations = KeyType.allCases.reduce(into: [:]) { $0[$1] = polyglot.label(forKey: $1) }
    }
}
