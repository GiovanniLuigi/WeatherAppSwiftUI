//
//  WeatherService.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func getCurrentWeather(for city: City) async throws -> Weather
}

struct WeatherService: WeatherServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getCurrentWeather(for city: City) async throws -> Weather {
        let response: CurrentWeatherResponse = try await httpClient.request(endpoint: WeatherEndpoint.getCurrent(cityId: city.id))
        return response.current
    }
}

struct CurrentWeatherResponse: Decodable {
    let current: Weather
}
