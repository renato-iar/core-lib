import Foundation

public protocol ReadableCache {

    func read<T: Codable>(identifier: String, secondaryIdentifier: String?) throws -> T

    func exists(identifier: String, secondaryIdentifier: String?) -> Bool
}

public extension ReadableCache {

    func read<T: Codable>(_: T.Type, identifier: String, secondaryIdentifier: String? = nil) throws -> T {
        try self.read(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }

    func read<T: Codable>(identifier: String) throws -> T {

        return try self.read(identifier: identifier, secondaryIdentifier: nil)
    }

    func exists(identifier: String) -> Bool {

        return self.exists(identifier: identifier, secondaryIdentifier: nil)
    }
}
