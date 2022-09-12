//
//  URLRequestRouter.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

import Foundation

public protocol URLRequestRouter: ThrowingUseCase where InputType == URLRequestRouterInput,
                                                        OutputType == URLRequest { }

public extension URLRequestRouter {

    func route(input: InputType) throws -> OutputType {

        return try self.execute(input: input)
    }
}
