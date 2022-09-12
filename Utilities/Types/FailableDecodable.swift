//
//  FailableDecodable.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 25/08/2022.
//

import Foundation

struct FailableDecodable<DecodedType: Decodable>: Decodable {

    let result: DecodedType?
    let error: Error?

    init(from decoder: Swift.Decoder) throws {

        do {
            self.result = try DecodedType.init(from: decoder)
            self.error = nil
        } catch {
            self.result = nil
            self.error = error
        }
    }
}
