//
//  HTTPMethod.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 5/10/22.
//

import Foundation

public struct HTTPMethod: Hashable {
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    
    public let rawValue: String
}
