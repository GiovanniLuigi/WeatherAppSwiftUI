//
//  CityService.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 17/12/24.
//
import Foundation

enum ServiceError: Error {
    case network
    case parsing
    case databse
    case unknown
}

protocol CityServiceProtocol {
    // My choice here is to return an nil (or empty array) instead of throwing erros in the cases of:
    // - no city in cache
    // - no city found in search
    func loadCachedCity() async throws -> City?
    func searchCity(query: String) async throws -> [City]
}

struct CityService: CityServiceProtocol {
    private let httpClient: HTTPClientProtocol
    private let storageClient: StorageClientProtocol
    
    
    func loadCachedCity() async throws -> City? {
        try await storageClient.load(key: "city")
    }
    
    func searchCity(query: String) async throws -> [City] {
        try await httpClient.request(endpoint: CityEndpoint.search(query: query))
    }
}

struct WeatherService: WeatherServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func getCurrentWeather(for city: City) async throws -> Weather {
        let response: WeatherResponse = try await httpClient.request(endpoint: WeatherEndpoint.getCurrent(cityId: city.id))
        return response.current
    }
}

struct WeatherResponse: Decodable {
    let current: Weather
}

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

protocol WeatherServiceProtocol {
    func getCurrentWeather(for city: City) async throws -> Weather
}

struct City: Codable {
    let id: Int
    let name: String
}

protocol StorageClientProtocol {
    func load<T: Codable>(key: String) async throws -> T
}

protocol HTTPClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}

struct HTTPClient: HTTPClientProtocol {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url else {
            throw ServiceError.network
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ServiceError.network
        }

        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            throw ServiceError.parsing
        }
    }
}

protocol Endpoint {
    // These could be enums, but for simplicity I'll leave them as Strings
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}

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
            return "api.weatherapi.com/v1"
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/search.json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .search(let query):
            return [
                .init(name: "q", value: query),
                .init(name: "key", value: apiKey)
            ]
        }
    }
    
    var method: String {
        switch self {
        case .search:
            return "GET"
        }
    }
    
    func buildURL(for env: Environment) -> URL? {
        
    }
}

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
                .init(name: "key", value: apiKey),
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
