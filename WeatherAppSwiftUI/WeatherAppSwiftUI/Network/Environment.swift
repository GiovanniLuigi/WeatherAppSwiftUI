//
//  Environment.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 17/12/24.
//

enum Environment {
    case development
    
    // In a real-world situation this shouldn't be hard-coded here
    var apiKey: String {
        switch self {
        case .development:
            return "e32ea7bcce1640838cb180114241712"
        }
    }
    
    var baseURL: String {
        switch self {
        case .development:
            return "api.weatherapi.com"
        }
    }
}
