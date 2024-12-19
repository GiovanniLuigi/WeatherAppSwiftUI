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
    case loadedSearchResults
    case error(message: String, retry: () -> Void)
}

struct CityWeather: Identifiable {
    var id: Int { city.id }
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
    private let weatherService: WeatherServiceProtocol
    private var searchTask: Task<Void, Never>?
    
    init(cityService: CityServiceProtocol, weatherService: WeatherServiceProtocol) {
        self.cityService = cityService
        self.weatherService = weatherService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                // Should do any other validation to the query?
                if query.isEmpty {
                    self?.cleanSearch()
                } else {
                    self?.performSearch(with: query)
                }
            }
            .store(in: &cancellables)
    }
    
    deinit {
        searchTask?.cancel()
        searchTask = nil
    }
    
    func loadCachedCity() async {
        guard let city = try? await cityService.loadCachedCity() else {
            viewState = .loadedCachedCity
            return
        }
        
        guard let weather = try? await weatherService.getCurrentWeather(for: city) else {
            viewState = .loadedCachedCity
            return
        }
        
        self.selectedCity = CityWeather(city: city, weather: weather)
        viewState = .loadedCachedCity
    }
    
    func select(_ cityWeather: CityWeather) {
        Task { [weak self] in
            do {
                try await self?.cityService.saveCity(cityWeather.city)
                self?.selectedCity = cityWeather
                self?.viewState = .loadedCachedCity
            } catch {
                self?.viewState = .error(message: "We're sorry, it was not possible to select this city. You can retry it later", retry: { [weak self] in
                    self?.select(cityWeather)
                })
            }
        }
    }
    
    private func cleanSearch() {
        searchResults = []
        viewState = .loadedCachedCity
    }
    
    private func performSearch(with query: String) {
        self.searchTask?.cancel()
        self.searchTask = nil
        self.searchTask = Task {
            do {
                self.viewState = .isSearching
                let cities = try await cityService.searchCity(query: query)
                guard !cities.isEmpty else {
                    viewState = .noSearchResults
                    return
                }
                let weathersByCityId = try await getCurrentWeather(for: cities)
                self.searchResults = cities.compactMap({ city in
                    guard let weather = weathersByCityId[city.id] else { return nil }
                    return CityWeather(city: city, weather: weather)
                })
                self.viewState = .loadedSearchResults
            } catch {
                self.viewState = .error(message: "We're sorry, it was not possible to search this location. You can retry it later", retry: { [weak self] in
                    self?.performSearch(with: query)
                })
            }
        }
    }
    
    private func getCurrentWeather(for cities: [City]) async throws -> [Int: Weather] {
        var weathers: [Int: Weather] = [:]
        for city in cities {
            weathers[city.id] = try await weatherService.getCurrentWeather(for: city)
        }
        return weathers
    }
}
