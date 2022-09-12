//
//  WriteableStore.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 16/08/2022.
//

import Foundation

public protocol WriteableStore {

    func write(_ data: Data, identifier: String, secondaryIdentifier: String?) throws
    func delete(identifier: String, secondaryIdentifier: String?) throws
}

public extension WriteableStore {

    func write(_ data: Data, identifier: String) throws {

        try self.write(data, identifier: identifier, secondaryIdentifier: nil)
    }

    func delete(identifier: String) throws {

        try self.delete(identifier: identifier, secondaryIdentifier: nil)
    }
}
