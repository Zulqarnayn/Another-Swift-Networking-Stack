//
//  HTTPBody.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 7/10/22.
//

import Foundation

public protocol HTTPBody {
    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
    func encode() throws -> Data
}

extension HTTPBody {
    public var isEmpty: Bool { false }
    public var additionalHeaders: [String: String] { [:] }
}

// EmptyBody
public struct EmptyBody: HTTPBody {
    public var isEmpty = true
    
    public init() {}
    public func encode() throws -> Data {
        return Data()
    }
}

public struct DataBody: HTTPBody {
    private let data: Data
    
    public var isEmpty: Bool { return data.isEmpty }
    public var additionalHeaders: [String : String]
    
    init(data: Data, additionalHeaders: [String : String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }
    
    public func encode() throws -> Data {
        data
    }
}
/*
 we can easily wrap an existing Data value into an HTTPBody for our request
 let otherData: Data = ...
 var request = HTTPRequest()
 request.body = DataBody(otherData)
 */

public struct JSONBody: HTTPBody {
    public var isEmpty: Bool = false
    
    public var additionalHeaders = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    
    private let tryEncode: () throws -> Data
    
    init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        tryEncode = { try encoder.encode(value) }
    }
    
    public func encode() throws -> Data {
        return try tryEncode()
    }
}

public struct FormBody: HTTPBody {
    private let values: [URLQueryItem]
    public var isEmpty: Bool { values.isEmpty }
    public var additionalHeaders = [
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    ]
    
    init(_ values: [URLQueryItem]) {
        self.values = values
    }
    
    init(_ values: [String: String]) {
        let queryItems = values.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.init(queryItems)
    }
    
    public func encode() throws -> Data {
        let pieces = values.map(urlEncode)
        let bodyString = pieces.joined(separator: "&")
        print(bodyString, bodyString.utf8)
        return Data(bodyString.utf8)
    }
    
    func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }
    
    func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
    
}
