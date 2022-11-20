import Foundation

public struct URLRequestRouterInput {
    public let slug: String?
    public let parameters: [String: String]?
    public let username: String?
    public let password: String?

    public init(slug: String? = nil,
                parameters: [String: String]? = nil,
                username: String? = nil,
                password: String? = nil) {
        self.slug = slug
        self.parameters = parameters
        self.username = username
        self.password = password
    }
}
