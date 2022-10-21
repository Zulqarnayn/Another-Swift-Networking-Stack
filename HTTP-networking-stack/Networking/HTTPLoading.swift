//
//  HTTPLoading.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 8/10/22.
//

import Foundation

protocol HTTPLoading {
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void)
}
