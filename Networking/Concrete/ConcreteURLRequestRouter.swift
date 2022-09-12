//
//  ConcreteURLRequestRouter.swift
//  WeigthTracker
//
//  Created by Renato Ribeiro on 17/08/2022.
//

import Foundation

public final class ConcreteURLRequestRouter {

    // MARK: Properties

    private let baseURL: URL

    // MARK: Initialziers

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

// MARK: - Errors

extension ConcreteURLRequestRouter {

    public enum Errors: Error {

        case invalidBaseURL(URL)
        case invalidURLComposition
    }
}

// MARK: - URLRequestRouter

extension ConcreteURLRequestRouter: URLRequestRouter {

    public func execute(input: URLRequestRouterInput) throws -> URLRequest {

        guard var components = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            throw Errors.invalidBaseURL(self.baseURL)
        }

        if let slug = input.slug?.trimmingCharacters(in: .whitespaces), !slug.isEmpty {

            components.path += "/\(slug)"
        }

        var queryItems = components.queryItems ?? []

        input.parameters?.forEach { queryItems.append(URLQueryItem(name: $0, value: $1)) }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw Errors.invalidURLComposition
        }

        components.user = input.username
        components.password = input.password

        return URLRequest(url: url)
    }
}
