//
//  Endpoint.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

protocol Endpoint {
    // These could be enums, but for simplicity I'll leave them as Strings
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: String { get }
}
