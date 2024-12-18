//
//  HomeViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import SwiftUI
import Combine

protocol HomeViewModelProtocol {
    
}

enum HomeViewState {
    case isLoadingCachedCity
    case loadedCachedCity
    case isSearching
    case noSearchResults
    case error
}

struct CityWeather {
    let city: City
    let weather: Weather
}

@MainActor
final class HomeViewModel: ObservableObject, HomeViewModelProtocol {
    @Published var searchText: String = ""
    @Published private(set) var selectedCity: CityWeather?
    @Published private(set) var searchResults: [CityWeather] = []
    
    @Published private(set) var viewState: HomeViewState = .isLoadingCachedCity
    
    private var cancellables: Set<AnyCancellable> = []
    private let cityService: CityServiceProtocol
    
    init(cityService: CityServiceProtocol) {
        self.cityService = cityService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                // Should do any other validation to the query?
                self?.performSearch(with: query)
            }
            .store(in: &cancellables)
    }
    
    func loadCachedCity() async {
        viewState = .loadedCachedCity
    }
    
    private func performSearch(with query: String) {
        
    }
}
