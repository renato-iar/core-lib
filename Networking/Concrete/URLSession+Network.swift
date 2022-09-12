//
//  URLSession+Network.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 16/08/2022.
//

import Foundation
import Networking_API

extension URLSession: Network {

    public func data(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> Data {

        return try await self.data(for: request, delegate: delegate).0
    }

    public func data(url: URL, delegate: URLSessionTaskDelegate?) async throws -> Data {

        return try await self.data(from: url, delegate: delegate).0
    }
}
