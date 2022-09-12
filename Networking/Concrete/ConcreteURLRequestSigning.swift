//
//  ConcreteURLRequestSigning.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

import Foundation

public final class ConcreteURLRequestSigning { }

extension ConcreteURLRequestSigning: URLRequestSigning {

    /// We currently do not explicitly sign requests
    public func execute(input: URLRequest) throws -> URLRequest {

        return input
    }
}
