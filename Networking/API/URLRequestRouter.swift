import Foundation

public protocol URLRequestRouter {
    func route(input: URLRequestRouterInput) throws -> URLRequest
}
