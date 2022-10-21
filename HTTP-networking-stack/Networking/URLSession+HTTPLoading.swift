//
//  URLSession+HTTPLoading.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 8/10/22.
//

import Foundation
/*
 URLSession is where the “rubber meets the road”.
 It’s the last hurdle to clear before our requests
 go out over the air (or wires) to the servers we’ve indicated.
 So it makes sense that our implementation of HTTPLoading on
 a URLSession will be about translating the HTTPRequest into
 the URLRequest that the session needs
 */

extension URLSession: HTTPLoading {
    var session: URLSession {
        return URLSession.shared
    }
    
    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        guard let url = request.url else {
            completion(.failure(HTTPError(code: .invalidRequest, request: request, response: nil, underlyingError: nil)))
            print("Couldn't construct a proper URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }
        
        if request.body.isEmpty == false {
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }
            
            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                completion(.failure(
                    HTTPError(code: .couldnotEncodeBody, request: request, response: nil, underlyingError: error)
                ))
                
                return
            }
        }
        
        let dataTask = session.dataTask(with: urlRequest) {
            (data, response, error) in
            
            let result = HTTPResult(request: request, responseData: data, response: response, error: error)
            
            completion(result)
        }
        
        dataTask.resume()
    }
}
