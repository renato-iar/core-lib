public protocol Cache {

    associatedtype ReadableCacheType: ReadableCache
    associatedtype WriteableCacheType: ReadableCache & WriteableCache
    associatedtype ImageCacheType: ImageCache

    var readable: ReadableCacheType { get }
    var writeable: WriteableCacheType { get }
    var image: ImageCacheType { get }
}
