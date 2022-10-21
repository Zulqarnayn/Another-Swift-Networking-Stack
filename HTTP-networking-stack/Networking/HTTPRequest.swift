//
//  HTTPRequest.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 5/10/22.
//

import Foundation

public struct HTTPRequest {
    private var urlComponents = URLComponents()
    public var method: HTTPMethod = .get
    public var headers: [String: String] = [:]
    public var body: HTTPBody = EmptyBody()
    
    public var url: URL? {
        urlComponents.url
    }
    
    public init() {
        urlComponents.scheme = "https"
    }
}

/*
 This way we can hide things that we probably won’t need (perhaps the .port?
 Or the .query string that represents the composed query items),
 and re-expose them if they’re needed.
 */
public extension HTTPRequest {
    var scheme: String { urlComponents.scheme ?? "https" }
    
    var host: String? {
        get { urlComponents.host }
        set { urlComponents.host = newValue }
    }
    
    var path: String {
        get { urlComponents.path }
        set { urlComponents.path = newValue }
    }
}
