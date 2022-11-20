import Combine
import Localization_API
import Localization

public final class MockPolyglot: Polyglot {

    public typealias LocaleKeyType = LanguageType
    public typealias Key = String
    public typealias Label = String

    private let subject: CurrentValueSubject<LocaleKeyType, Never>

    var translations: [LocaleKeyType: [Key: Label]] = LocaleKeyType.allCases.reduce(into: [:]) { $0[$1] = [:] }

    public init(locale: LocaleKeyType = .en) {
        self.subject = .init(locale)
    }

    public var locale: LocaleKeyType { self.subject.value }
    public var localePublisher: any PublisherType { self.subject.eraseToAnyPublisher() }

    public func label(for key: String) -> String {
        return self.translations[self.locale]?[key] ?? key
    }

    public func set(locale: LanguageType, force: Bool) throws {
        self.subject.value = locale
    }
}
