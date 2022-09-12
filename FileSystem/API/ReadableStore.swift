//
//  ReadableStore.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 16/08/2022.
//

import Foundation

public protocol ReadableStore {

    var resource: URL { get }

    func read(identifier: String, secondaryIdentifier: String?) throws -> Data
    func exists(identifier: String, secondaryIdentifier: String?) -> Bool
}

public extension ReadableStore {

    func read(identifier: String) throws -> Data {

        return try self.read(identifier: identifier, secondaryIdentifier: nil)
    }

    func exists(identifier: String) -> Bool {

        return self.exists(identifier: identifier, secondaryIdentifier: nil)
    }
}
