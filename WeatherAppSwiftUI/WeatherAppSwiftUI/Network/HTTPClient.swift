//
//  HTTPClient.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

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
        
        var request = URLRequest(url: url, timeoutInterval: 30)
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
