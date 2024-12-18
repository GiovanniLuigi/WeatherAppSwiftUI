//
//  CityService.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

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
    
    init(httpClient: HTTPClientProtocol, storageClient: StorageClientProtocol) {
        self.httpClient = httpClient
        self.storageClient = storageClient
    }
    
    func loadCachedCity() async throws -> City? {
        try await storageClient.load(key: "city")
    }
    
    func searchCity(query: String) async throws -> [City] {
        try await httpClient.request(endpoint: CityEndpoint.search(query: query))
    }
}
