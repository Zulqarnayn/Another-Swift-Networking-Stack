//
//  StarWarsAPI.swift
//  HTTP-networking-stack
//
//  Created by Asif Mujtaba on 21/10/22.
//

import Foundation

public class StarWarsAPI {
    private let loader: HTTPLoading = URLSession.shared
    
    func requestPeople(completion: @escaping (People?) -> Void) {
        var request = HTTPRequest()
        request.host = "swapi.dev"
        request.path = "/api/people/1/"
        
        loader.load(request: request) { result in
            if let body = result.response?.body {
                let decodedResponse = try? JSONDecoder().decode(People.self, from: body)
                completion(decodedResponse)
            }
        }
    }
}


struct People: Codable {
    let birthYear, eyeColor: String
    let films: [String]
    let gender, hairColor, height: String
    let homeworld: String
    let mass, name, skinColor, created: String
    let edited: String
    let species, starships: [String]
    let url: String
    let vehicles: [String]

    enum CodingKeys: String, CodingKey {
        case birthYear = "birth_year"
        case eyeColor = "eye_color"
        case films, gender
        case hairColor = "hair_color"
        case height, homeworld, mass, name
        case skinColor = "skin_color"
        case created, edited, species, starships, url, vehicles
    }
}
