//
//  FileStore.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation
import FileSystem_API

public final class FileStore {

    // MARK: Properties

    private let baseURL: URL

    public let storeType: StoreType

    // MARK: Initializers

    public init?(baseFolder: String,
                 storeType: StoreType) {

        let folder: URL

        switch storeType {

        case .persistent:
            guard let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

            folder = documents

        case .volatile:
            guard let cache = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

            folder = cache
        }

        if #available(iOS 16.0, *) {
            self.baseURL = folder.appending(path: baseFolder, directoryHint: .inferFromPath)
        } else {
            self.baseURL = folder.appendingPathComponent(baseFolder)
        }

        self.storeType = storeType
    }
}

// MARK: - Types

public extension FileStore {

    enum StoreType {

        case volatile
        case persistent
    }
}

// MARK: - ReadableStore

extension FileStore: ReadableStore {

    public var resource: URL { self.baseURL }

    public func read(identifier: String, secondaryIdentifier: String?) throws -> Data {

        return try Data(contentsOf: self.url(for: identifier, secondaryIdentifier: secondaryIdentifier).destination)
    }

    public func exists(identifier: String, secondaryIdentifier: String?) -> Bool {

        let url = self.url(for: identifier, secondaryIdentifier: secondaryIdentifier).destination
        var isDirectory = ObjCBool(booleanLiteral: false)

        return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue
    }
}

// MARK: - WriteableStore

extension FileStore: WriteableStore {

    public func write(_ data: Data, identifier: String, secondaryIdentifier: String?) throws {

        let (enclosingUrl, url) = self.url(for: identifier, secondaryIdentifier: secondaryIdentifier)

        var isDirectory = ObjCBool(booleanLiteral: false)

        if !FileManager.default.fileExists(atPath: enclosingUrl.path, isDirectory: &isDirectory) || !isDirectory.boolValue {

            try FileManager.default.createDirectory(at: enclosingUrl, withIntermediateDirectories: true)
        }

        try data.write(to: url, options: Data.WritingOptions.atomic)
    }

    public func delete(identifier: String, secondaryIdentifier: String?) throws {

        let url = self.url(for: identifier, secondaryIdentifier: secondaryIdentifier).destination

        var isDirectory = ObjCBool(booleanLiteral: false)

        if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory), !isDirectory.boolValue {

            try FileManager.default.removeItem(at: url)
        }
    }
}

// MARK: - Utils

private extension FileStore {

    func url(for identifier: String, secondaryIdentifier: String?) -> (enclosingFolder: URL, destination: URL) {

        var enclosingUrl = self.baseURL
        var url: URL

        if #available(iOS 16, *) {
            url = enclosingUrl.appending(path: identifier, directoryHint: .inferFromPath)
        } else {
            url = enclosingUrl.appendingPathComponent(identifier)
        }

        if let secondaryIdentifier = secondaryIdentifier {

            enclosingUrl = url

            if #available(iOS 16, *) {
                url = enclosingUrl.appending(path: secondaryIdentifier, directoryHint: .inferFromPath)
            } else {
                url = enclosingUrl.appendingPathComponent(secondaryIdentifier)
            }
        }

        return (enclosingUrl, url)
    }
}
