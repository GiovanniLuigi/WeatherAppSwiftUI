//
//  StorageClient.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

protocol StorageClientProtocol {
    func load<T: Codable>(key: String) async throws -> T?
    func save<T: Codable>(key: String, value: T) async throws
}

struct UserDefaultsStorageClient: StorageClientProtocol {
    private let storage: UserDefaults
    
    init(storage: UserDefaults = UserDefaults.standard) {
        self.storage = storage
    }
    
    func load<T: Codable>(key: String) async throws -> T? {
        guard let encoded = storage.data(forKey: key) else {
            return nil
        }
        return try JSONDecoder().decode(T.self, from: encoded)
    }
    
    func save<T: Codable>(key: String, value: T) async throws {
        let encoded = try JSONEncoder().encode(value)
        storage.set(encoded, forKey: key)
    }
}
