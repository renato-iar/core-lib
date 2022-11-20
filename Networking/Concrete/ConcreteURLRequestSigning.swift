import Foundation
import Networking_API

public final class ConcreteURLRequestSigning { }

extension ConcreteURLRequestSigning: URLRequestSigning {
    /// We currently do not explicitly sign requests
    public func sign(request: URLRequest) throws -> URLRequest { request }
}
