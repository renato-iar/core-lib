//
//  CacheError.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation

public enum CacheError: Error {

    case ttlExceeded(expired: TimeInterval, current: TimeInterval)
}

public enum ImageCacheError: Error {

    case imageDecodingFailed
}
