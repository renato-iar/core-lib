//
//  CacheManager.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation

import Cache_API
import FileSystem_API
import FileSystem
import Networking_API
import Networking
import Utilities

public final class ConcreteCacheManager: CacheManager {

    // MARK: Properties
    private let network: any Network
    private let persistentStoreReader: any ReadableStorage
    private let persistentStoreWriter: any WriteableStorage
    private let volatileStoreReader: any ReadableStorage
    private let volatileStoreWriter: any WriteableStorage
    private let encoder: any Encoder
    private let decoder: any Decoder
    private let timestampProvider: any TimestampProvider

    public private(set) lazy var persistent: some Cache = ReadableWriteableCache(network: self.network,
                                                                                 storeReader: self.persistentStoreReader,
                                                                                 storeWriter: self.persistentStoreWriter,
                                                                                 encoder: self.encoder,
                                                                                 decoder: self.decoder,
                                                                                 timestampProvider: self.timestampProvider)
    public private(set) lazy var volatile: some Cache = ReadableWriteableCache(network: self.network,
                                                                               storeReader: self.volatileStoreReader,
                                                                               storeWriter: self.volatileStoreWriter,
                                                                               encoder: self.encoder,
                                                                               decoder: self.decoder,
                                                                               timestampProvider: self.timestampProvider)

    // MARK: Initializers

    public init(network: any Network,
                persistentStoreReader: any ReadableStorage,
                persistentStoreWriter: any WriteableStorage,
                volatileStoreReader: any ReadableStorage,
                volatileStoreWriter: any WriteableStorage,
                encoder: any Encoder,
                decoder: any Decoder,
                timestampProvider provider: any TimestampProvider) {
        self.network = network
        self.persistentStoreReader = persistentStoreReader
        self.persistentStoreWriter = persistentStoreWriter
        self.volatileStoreReader = volatileStoreReader
        self.volatileStoreWriter = volatileStoreWriter
        self.encoder = encoder
        self.decoder = decoder
        self.timestampProvider = provider
    }
}

// MARK: - Shared

extension ConcreteCacheManager {

    public static var shared: some CacheManager = {

        guard let persistentStore = FileStore(baseFolder: "persistent", storeType: .persistent) else {
            fatalError("Failed to create persistent store")
        }

        guard let volatileStore = FileStore(baseFolder: "volatile", storeType: .volatile) else {
            fatalError("Failed to create volatile store")
        }

        return ConcreteCacheManager(network: URLSession.shared,
                                    persistentStoreReader: persistentStore,
                                    persistentStoreWriter: persistentStore,
                                    volatileStoreReader: volatileStore,
                                    volatileStoreWriter: volatileStore,
                                    encoder: JSONEncoder(),
                                    decoder: JSONDecoder(),
                                    timestampProvider: Calendar.current)
    }()
}
