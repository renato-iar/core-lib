//
//  File.swift
//  
//
//  Created by Renato Ribeiro on 10/09/2022.
//

import Foundation
import Cache_API

extension Calendar: TimestampProvider {
    public func current() -> TimeInterval { Date().timeIntervalSince1970 }
}
