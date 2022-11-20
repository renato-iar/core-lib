import Foundation

public enum CacheError: Error {

    case ttlExceeded(expired: TimeInterval, current: TimeInterval)
}

public enum ImageCacheError: Error {

    case imageDecodingFailed
}
