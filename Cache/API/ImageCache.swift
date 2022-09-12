//
//  ImageCache.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 16/08/2022.
//

import UIKit

public protocol ImageCache {

    func image(from url: URL, identifier: String, scale: CGFloat, ttl: CacheItemTTL) async throws -> UIImage

    func delete(imageFrom url: URL, identifier: String) throws

    func exists(imageFrom url: URL, identifier: String) -> Bool
}

public extension ImageCache {

    func image(from url: URL, identifier: String, scale: CGFloat = 1, ttl: CacheItemTTL = .indefinite) async throws -> UIImage {

        return try await self.image(from: url, identifier: identifier, scale: scale, ttl: ttl)
    }
}
