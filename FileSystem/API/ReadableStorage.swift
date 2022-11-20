import Foundation

public protocol ReadableStorage {
    var resource: URL { get }

    func read(identifier: String, secondaryIdentifier: String?) throws -> Data
    func exists(identifier: String, secondaryIdentifier: String?) -> Bool
}

public extension ReadableStorage {
    func read(identifier: String) throws -> Data {
        return try self.read(identifier: identifier, secondaryIdentifier: nil)
    }

    func exists(identifier: String) -> Bool {
        return self.exists(identifier: identifier, secondaryIdentifier: nil)
    }
}
