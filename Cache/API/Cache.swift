//
//  Cache.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

public protocol Cache {

    associatedtype ReadableCacheType: ReadableCache
    associatedtype WriteableCacheType: ReadableCache & WriteableCache
    associatedtype ImageCacheType: ImageCache

    var readable: ReadableCacheType { get }
    var writeable: WriteableCacheType { get }
    var image: ImageCacheType { get }
}
