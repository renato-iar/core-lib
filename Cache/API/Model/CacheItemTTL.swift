import Foundation

public enum CacheItemTTL: Codable {
    case indefinite
    case finite(TimeInterval)
}
