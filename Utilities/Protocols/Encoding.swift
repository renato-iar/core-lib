//
//  Encoding.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 15/08/2022.
//

import Foundation

public protocol Encoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

public protocol Decoder {

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

public extension Decoder {

    func decode<T: Decodable>(from data: Data) throws -> T {
        try self.decode(T.self, from: data)
    }
}

extension JSONDecoder: Decoder { }

extension JSONEncoder: Encoder { }
