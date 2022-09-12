//
//  Polyglot.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Combine
import Foundation

public protocol Polyglot {

    associatedtype LocaleKeyType: RawRepresentable where LocaleKeyType.RawValue == String
    typealias PublisherType = Publisher<LocaleKeyType, Never>

    var locale: LocaleKeyType { get }
    var localePublisher: any PublisherType { get }

    func label(for key: String) -> String
    func set(locale: LocaleKeyType, force: Bool)
}

public extension Polyglot {

    func label<KeyType: RawRepresentable>(forKey key: KeyType) -> String where KeyType.RawValue == String {
        self.label(for: key.rawValue)
    }

    func set(locale: LocaleKeyType) {
        self.set(locale: locale, force: false)
    }
}
