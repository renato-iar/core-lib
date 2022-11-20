import Foundation

public protocol WriteableCache {

    func write<T: Codable>(_ value: T, identifier: String, secondaryIdentifier: String?, ttl: CacheItemTTL) throws

    func delete(identifier: String, secondaryIdentifier: String?) throws
}

public extension WriteableCache {

    func write<T: Codable>(_ value: T, identifier: String, secondaryIdentifier: String? = nil, ttl: CacheItemTTL = .indefinite) throws {

        try self.write(value, identifier: identifier, secondaryIdentifier: secondaryIdentifier, ttl: ttl)
    }

    func delete(identifier: String) throws {

        try self.delete(identifier: identifier, secondaryIdentifier: nil)
    }
}
