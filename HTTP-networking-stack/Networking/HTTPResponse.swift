//
//  HTTPResponse.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 5/10/22.
//

import Foundation

public struct HTTPStatus {
    public let rawValue: Int
}

public struct HTTPResponse {
    public let request: HTTPRequest
    private let response: HTTPURLResponse
    public let body: Data?
    
    init(request: HTTPRequest, response: HTTPURLResponse, body: Data?) {
        self.request = request
        self.response = response
        self.body = body
    }
    
    public var status: HTTPStatus {
        HTTPStatus(rawValue: response.statusCode)
    }
    
    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }
    
    public var headers: [AnyHashable: Any] { response.allHeaderFields }
}

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

public struct HTTPError: Error {
    public let code: Code
    
    public let request: HTTPRequest
    
    public let response: HTTPResponse?
    
    public let underlyingError: Error?
    
    public enum Code {
        case invalidRequest
        case cannotConnect
        case cancelled
        case insecureConnection
        case invalidResponse
        case couldnotEncodeBody
        case unsupportedURL
        case cannotFindHost
        case unknown
    }
}

extension HTTPResult {
    
    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let r = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: r, body: responseData ?? Data())
        }

        if let e = error as? URLError {
            let code: HTTPError.Code
            switch e.code {
            case .badURL: code = .invalidRequest
            case .unsupportedURL: code = .unsupportedURL
            case .cannotFindHost: code = .cannotFindHost
            default: code = .unknown
            }
            self = .failure(HTTPError(code: code, request: request, response: httpResponse, underlyingError: e))
        } else if let someError = error {
            // an error, but not a URL error
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: someError))
        } else if let r = httpResponse {
            // not an error, and an HTTPURLResponse
            self = .success(r)
        } else {
            // not an error, but also not an HTTPURLResponse
            self = .failure(HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: error))
        }
    }
    
    public var request: HTTPRequest {
        switch self {
        case .success(let response): return response.request
        case .failure(let error): return error.request
        }
    }
    
    public var response: HTTPResponse? {
        switch self {
        case .success(let response): return response
        case .failure(let error): return error.response
        }
    }
}
