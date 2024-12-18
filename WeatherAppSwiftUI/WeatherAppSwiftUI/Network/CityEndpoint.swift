//
//  CityEndpoint.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

enum CityEndpoint: Endpoint {
    case search(query: String)
    
    var scheme: String {
        switch self {
        case .search:
            return "http"
        }
    }
    
    var baseURL: String {
        switch self {
        case .search:
            return "api.weatherapi.com"
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/v1/search.json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .search(let query):
            return [
                .init(name: "q", value: query),
                .init(name: "key", value: Environment.development.apiKey)
            ]
        }
    }
    
    var method: String {
        switch self {
        case .search:
            return "GET"
        }
    }
}
