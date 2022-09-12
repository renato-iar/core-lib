//
//  ConcretePolyglot.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Combine
import Foundation

import Cache_API
import Cache
import Localization_API
import Logging_API
import Logging
import Utilities

public enum LanguageType: String {

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
         decoder: Decoder = JSONDecoder()) {
        self.decoder = decoder
        self.bundle = bundle
        self.subject = .init(locale)
        self.cacheManager = cache
        self.logger = logger

        self.loadLanguage(for: locale)
    }

    // MARK: Shared

    public static let shared = ConcretePolyglot(initialLocale: .ptPT)
}

// MARK: - Polyglot

extension ConcretePolyglot: Polyglot {

    public typealias LocaleKeyType = LanguageType

    public var localePublisher: any PublisherType { self.subject.eraseToAnyPublisher() }
    public var locale: LanguageType { self.subject.value }

    public func label(for key: String) -> String {
        self.translations[locale]?[key] ?? key
    }

    public func set(locale: LanguageType, force: Bool) {

        guard self.translations[locale] == nil || force else { return }

        self.loadLanguage(for: locale) { [weak self] error in
            if error != nil {
                self?.subject.value = locale
            }
        }
    }
}

// MARK: - Private (loader)

private extension ConcretePolyglot {

    func loadLanguage(for locale: LocaleKeyType, completion: ((Error?) -> Void)? = nil) {
        do {
            try self.loadLanguageFromCache(for: locale)

            completion?(nil)

        } catch {

            do {
                try self.loadLanguageFromBundle(for: locale)

                completion?(nil)
            } catch {
                Task { await self.logger.log(error.localizedDescription, level: .error) }

                completion?(ConcretePolyglotError.unableToLoad(language: locale, underlyingError: error))
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
