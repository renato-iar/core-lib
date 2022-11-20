import Combine
import Foundation

import Cache_API
import Cache
import Localization_API
import Logging_API
import Logging
import Utilities

public enum LanguageType: String, CaseIterable {

    case en = "en"
    case enUS = "en-US"
    case ptPT = "pt-PT"
    case ptBR = "pt-BR"
}

public enum ConcretePolyglotError: Error {
    case missingBundle(language: LanguageType)
    case unableToLoad(language: LanguageType, underlyingError: Error?)
}

public final class ConcretePolyglot: ObservableObject {

    // MARK: Properties

    private let decoder: Decoder
    private let bundle: Bundle
    private let subject: CurrentValueSubject<LocaleKeyType, Never>
    private let cacheManager: any CacheManager
    private let logger: any Logging

    private typealias Key = String
    private typealias Label = String

    private var translations: [LocaleKeyType: [Key: Label]] = [:]

    // MARK: Initializers

    init(initialLocale locale: LocaleKeyType,
         cache: any CacheManager = ConcreteCacheManager.shared,
         bundle: Bundle = Bundle.main,
         logger: Logging = ConcreteLogger.shared,
         decoder: Decoder = JSONDecoder()) throws {
        self.decoder = decoder
        self.bundle = bundle
        self.subject = .init(locale)
        self.cacheManager = cache
        self.logger = logger

        try self.loadLanguage(for: locale)
    }

    private init(with locale: LocaleKeyType,
                 cache: any CacheManager = ConcreteCacheManager.shared,
                 bundle: Bundle = Bundle.main,
                 logger: Logging = ConcreteLogger.shared,
                 decoder: Decoder = JSONDecoder()) {
        self.decoder = decoder
        self.bundle = bundle
        self.subject = .init(locale)
        self.cacheManager = cache
        self.logger = logger

        do {
            try self.loadLanguage(for: locale)
        } catch {
            Task { await self.logger.error(error.localizedDescription) }
        }
    }

    // MARK: Shared

    public static let shared = ConcretePolyglot(with: .ptPT)
}

// MARK: - Polyglot

extension ConcretePolyglot: Polyglot {

    public typealias LocaleKeyType = LanguageType

    public var localePublisher: any PublisherType { self.subject.eraseToAnyPublisher() }
    public var locale: LanguageType { self.subject.value }

    public func label(for key: String) -> String {
        self.translations[locale]?[key] ?? key
    }

    public func set(locale: LanguageType, force: Bool) throws {

        guard self.translations[locale] == nil || force else { return }

        try self.loadLanguage(for: locale)

        self.subject.value = locale
    }
}

// MARK: - Private (loader)

private extension ConcretePolyglot {

    func loadLanguage(for locale: LocaleKeyType) throws {
        do {
            try self.loadLanguageFromCache(for: locale)
        } catch {

            do {
                try self.loadLanguageFromBundle(for: locale)
            } catch {
                Task { await self.logger.log(error.localizedDescription, level: .error) }

                throw error
            }
        }
    }

    func loadLanguageFromCache(for locale: LocaleKeyType) throws {
        self.translations[locale] = try self.cacheManager.persistent.readable.read(identifier: Constants.primaryCacheIdentifier,
                                                                                   secondaryIdentifier: locale.rawValue)
    }

    func loadLanguageFromBundle(for locale: LocaleKeyType) throws {
        guard let url = self.bundle.url(forResource: locale.rawValue, withExtension: Constants.payloadExtension) else { throw ConcretePolyglotError.missingBundle(language: locale) }

        let data = try Data.init(contentsOf: url)
        self.translations[locale] = try self.decoder.decode([Key:Label].self, from: data)
    }
}

// MARK: - Private (constants)

private extension ConcretePolyglot {

    enum Constants {
        static let payloadExtension = "json"
        static let primaryCacheIdentifier = "LabelsCache"
    }
}
