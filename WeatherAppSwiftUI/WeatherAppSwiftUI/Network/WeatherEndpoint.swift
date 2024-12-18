//
//  WeatherEndpoint.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

enum WeatherEndpoint: Endpoint {
    case getCurrent(cityId: Int)
    
    var scheme: String {
        switch self {
        case .getCurrent:
            return "http"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getCurrent:
            return "api.weatherapi.com"
        }
    }
    
    var path: String {
        switch self {
        case .getCurrent:
            return "/v1/current.json"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .getCurrent(let cityId):
            return [
                .init(name: "q", value: "id:\(cityId)"),
                .init(name: "key", value: Environment.development.apiKey),
                .init(name: "current_fields", value: "temp_c,uv,condition,humidity,feelslike_c")
            ]
        }
    }
    
    var method: String {
        switch self {
        case .getCurrent:
            return "GET"
        }
    }
}
