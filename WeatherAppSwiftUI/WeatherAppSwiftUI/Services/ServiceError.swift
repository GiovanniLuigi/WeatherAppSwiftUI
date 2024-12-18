//
//  ServiceError.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import Foundation

enum ServiceError: Error {
    case network
    case parsing
    case databse
    case unknown
}
