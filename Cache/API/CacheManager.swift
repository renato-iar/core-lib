public protocol CacheManager {
    associatedtype PersistentCacheType: Cache
    associatedtype VolatileCacheType: Cache

    var persistent: PersistentCacheType { get }
    var volatile: VolatileCacheType { get }
}
