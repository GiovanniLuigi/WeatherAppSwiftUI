//
//  StorageClient.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

protocol StorageClientProtocol {
    func load<T: Codable>(key: String) async throws -> T?
}

struct UserDefaultsStorageClient: StorageClientProtocol {
    func load<T: Codable>(key: String) async throws -> T? {
        return nil
    }
}
