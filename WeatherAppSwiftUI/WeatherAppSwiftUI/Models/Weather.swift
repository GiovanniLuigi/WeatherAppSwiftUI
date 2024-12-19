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
    
    init(temperature: Double, condition: WeatherCondition, humidity: Int, uvIndex: Double, feelsLikeTemperature: Double) {
        self.temperature = temperature
        self.condition = condition
        self.humidity = humidity
        self.uvIndex = uvIndex
        self.feelsLikeTemperature = feelsLikeTemperature
    }
    
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
    
    init(text: String, iconURL: String) {
        self.text = text
        self.iconURL = iconURL
    }
    
    enum CodingKeys: String, CodingKey {
        case text
        case iconURL = "icon"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        // Assuming that the data is consistent from the backend, might need refactor if it's not
        let iconURL = try container.decode(String.self, forKey: .iconURL)
        self.iconURL = "https:" + iconURL
    }
}
