import Foundation

public protocol URLRequestSigning {
    func sign(request: URLRequest) throws -> URLRequest
}
