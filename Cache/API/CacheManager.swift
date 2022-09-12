//
//  File.swift
//  
//
//  Created by Renato Ribeiro on 10/09/2022.
//

public protocol CacheManager {
    associatedtype PersistentCacheType: Cache
    associatedtype VolatileCacheType: Cache

    var persistent: PersistentCacheType { get }
    var volatile: VolatileCacheType { get }
}
