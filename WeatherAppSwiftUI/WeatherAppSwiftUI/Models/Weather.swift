//
//  Weather.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

struct Weather: Decodable {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Int
    let uvIndex: Double
    let feelsLikeTemperature: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case condition
        case humidity
        case uvIndex = "uv"
        case feelsLikeTemperature = "feelslike_c"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temperature = try container.decode(Double.self, forKey: .temperature)
        self.condition = try container.decode(WeatherCondition.self, forKey: .condition)
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.uvIndex = try container.decode(Double.self, forKey: .uvIndex)
        self.feelsLikeTemperature = try container.decode(Double.self, forKey: .feelsLikeTemperature)
    }
}

struct WeatherCondition: Decodable {
    let text: String
    let iconURL: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case iconURL = "icon"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.iconURL = try container.decode(String.self, forKey: .iconURL)
    }
}
