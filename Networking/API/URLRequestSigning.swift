//
//  URLRequestSigning.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

import Foundation

public protocol URLRequestSigning: ThrowingUseCase where InputType == URLRequest,
                                                         OutputType == URLRequest {
}

public extension URLRequestSigning {

    func sign(request: URLRequest) throws -> URLRequest {

        return try self.execute(input: request)
    }
}
