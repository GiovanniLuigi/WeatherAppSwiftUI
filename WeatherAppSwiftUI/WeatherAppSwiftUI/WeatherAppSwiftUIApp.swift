//
//  WeatherAppSwiftUIApp.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 17/12/24.
//

import SwiftUI

@main
struct WeatherAppSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(
                viewModel: HomeViewModel(
                    cityService: CityService(
                        httpClient: HTTPClient(),
                        storageClient: UserDefaultsStorageClient()
                    ),
                    weatherService: WeatherService(
                        httpClient: HTTPClient()
                    )
                )
            )
        }
    }
}
