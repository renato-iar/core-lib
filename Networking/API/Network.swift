import Foundation

public protocol Network {
    func data(request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> Data
    func data(url: URL, delegate: URLSessionTaskDelegate?) async throws -> Data
}

public extension Network {
    func data(request: URLRequest) async throws -> Data {
        return try await self.data(request: request, delegate: nil)
    }

    func data(url: URL) async throws -> Data {
        return try await self.data(url: url, delegate: nil)
    }
}
