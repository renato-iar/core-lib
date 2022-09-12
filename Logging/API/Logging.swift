//
//  Logger.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 01/09/2022.
//

import Foundation

public struct LogLevel: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension LogLevel {

    public static let none: LogLevel = []
    public static let trace = LogLevel(rawValue: 0x1 << 0)
    public static let error = LogLevel(rawValue: 0x1 << 1)
}

public protocol Logging {

    func log(_ message: String, level: LogLevel) async
}

public extension Logging {

    func trace(_ message: String) async {
        await self.log(message, level: .trace)
    }

    func error(_ message: String) async {
        await self.log(message, level: .error)
    }
}
