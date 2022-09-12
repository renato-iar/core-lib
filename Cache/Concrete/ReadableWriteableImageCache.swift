//
//  ReadableWriteableImageCache.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 16/08/2022.
//

import CryptoKit
import UIKit

import Cache_API

final class ReadableWriteableImageCache {

    private let network: any Network
    private let readableCache: any ReadableCache
    private let writeableCache: any WriteableCache

    init(network: any Network,
         readableCache: any ReadableCache,
         writeableCache: any WriteableCache) {

        self.network = network
        self.readableCache = readableCache
        self.writeableCache = writeableCache
    }
}

// MARK: - ImageCache

extension ReadableWriteableImageCache: ImageCache {

    func image(from url: URL, identifier: String, scale: CGFloat, ttl: CacheItemTTL) async throws -> UIImage {

        let secondaryIdentifier = Self.secondaryIdentifier(from: url)

        if let item: ImageCacheItem = try? self.readableCache.read(identifier: identifier, secondaryIdentifier: secondaryIdentifier),
           let image = UIImage(data: item.data, scale: item.scale) {

            return image
        }

        let data = try await self.network.data(url: url)

        try? self.writeableCache.write(data, identifier: "temp_image.png")

        guard let image = UIImage(data: data, scale: scale) else {

            throw ImageCacheError.imageDecodingFailed
        }

        let item = ImageCacheItem(data: data, scale: scale)

        do {

            try self.writeableCache.write(item, identifier: identifier, secondaryIdentifier: secondaryIdentifier, ttl: ttl)

        } catch { }

        return image
    }

    func delete(imageFrom url: URL, identifier: String) throws {

        let secondaryIdentifier = Self.secondaryIdentifier(from: url)

        try self.writeableCache.delete(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }

    func exists(imageFrom url: URL, identifier: String) -> Bool {

        let secondaryIdentifier = Self.secondaryIdentifier(from: url)

        return self.readableCache.exists(identifier: identifier, secondaryIdentifier: secondaryIdentifier)
    }
}

// MARK: - Types

private extension ReadableWriteableImageCache {

    struct ImageCacheItem: Codable {

        let data: Data
        let scale: CGFloat
    }
}

// MARK: - Utils

private extension ReadableWriteableImageCache {

    static func secondaryIdentifier(from url: URL) -> String {

        SHA256.hash(data: url.dataRepresentation).description
    }

    static func imageFormat(from url: URL) -> ImageFormat? {

        switch try? url.resourceValues(forKeys: [.fileResourceTypeKey]).typeIdentifier {

        case ImageFormat.png.rawValue:
            return .png

        case ImageFormat.jpg.rawValue:
            return .jpg

        case ImageFormat.jpeg.rawValue:
            return .jpeg

        default:
            return nil
        }
    }

    enum ImageFormat: String {

        case png
        case jpg
        case jpeg
    }
}
