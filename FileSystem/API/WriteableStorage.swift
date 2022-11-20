import Foundation

public protocol WriteableStorage {
    func write(_ data: Data, identifier: String, secondaryIdentifier: String?) throws
    func delete(identifier: String, secondaryIdentifier: String?) throws
}

public extension WriteableStorage {
    func write(_ data: Data, identifier: String) throws {
        try self.write(data, identifier: identifier, secondaryIdentifier: nil)
    }

    func delete(identifier: String) throws {
        try self.delete(identifier: identifier, secondaryIdentifier: nil)
    }
}
