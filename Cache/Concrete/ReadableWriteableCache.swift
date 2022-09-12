//
//  ReadableWriteableCache.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation
import Utilities

import Cache_API

public final class ReadableWriteableCache {

    // MARK: Properties

    private let network: any Network
    private let storeReader: any ReadableStore
    private let storeWriter: any WriteableStore
    private let encoder: any Encoder
    private let decoder: any Decoder
    private let timestampProvider: any TimestampProvider

    public private(set) lazy var imageCache: some ImageCache = ReadableWriteableImageCache(network: self.network,
                                                                                           readableCache: self.readable,
                                                                                           writeableCache: self.writeable)

    // MARK: Initializers

    public init(network: any Network,
                storeReader reader: ReadableStore,
                storeWriter writer: WriteableStore,
                encoder: Encoder = JSONEncoder(),
                decoder: Decoder = JSONDecoder(),
                timestampProvider provider: TimestampProvider) {
        self.network = network
        self.storeReader = reader
        self.storeWriter = writer
        self.encoder = encoder
        self.decoder = decoder
        self.timestampProvider = provider
    }
}

// MARK: - Types

private extension ReadableWriteableCache {
    struct CacheItem<T: Codable>: Codable {
        let storageTimestamp: TimeInterval
        let ttl: CacheItemTTL
        let value: T
    }
}

// MARK: - WriteableCache

extension ReadableWriteableCache: ReadableCache {
    public func read<T: Codable>(identifier: String, secondaryIdentifier: String?) throws -> T {
        let itemType = CacheItem<T>.self
        let data = try self.storeReader.read(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
        let item = try self.decoder.decode(itemType, from: data)

        if case let .finite(duration) = item.ttl {
            let current = self.timestampProvider.current()
            let expired = item.storageTimestamp + duration

            if current > expired {
                do {
                    try self.storeWriter.delete(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
                } catch { }

                throw CacheError.ttlExceeded(expired: expired,
                                             current: current)
            }
        }

        return item.value
    }

    public func exists(identifier: String, secondaryIdentifier: String?) -> Bool {
        return self.storeReader.exists(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }
}

// MARK: - WriteableCache

extension ReadableWriteableCache: WriteableCache {
    public func write<T: Codable>(_ value: T, identifier: String, secondaryIdentifier: String?, ttl: CacheItemTTL) throws {
        let now = self.timestampProvider.current()
        let item = CacheItem(storageTimestamp: now,
                             ttl: ttl,
                             value: value)
        let data = try self.encoder.encode(item)

        try self.storeWriter.write(data, identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }

    public func delete(identifier: String, secondaryIdentifier: String?) throws {
        try self.storeWriter.delete(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }
}

// MARK: - Cache

extension ReadableWriteableCache: Cache {
    public var readable: some ReadableCache { self }
    public var writeable: some (ReadableCache & WriteableCache) { self }
    public var image: some ImageCache { self.imageCache }
}
