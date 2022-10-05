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
        case unknown
    }
}

extension HTTPResult {
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
