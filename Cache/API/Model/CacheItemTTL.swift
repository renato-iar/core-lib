//
//  CacheItemTTL.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation

public enum CacheItemTTL: Codable {
    case indefinite
    case finite(TimeInterval)
}
