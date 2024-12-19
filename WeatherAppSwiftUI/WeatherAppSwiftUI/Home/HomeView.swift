//
//  HomeView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import SwiftUI

// TODO: add fonts
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // TODO: - add pull to refresh
    var body: some View {
        VStack(spacing: 0) {
            TextField(
                "",
                text: $viewModel.searchText,
                prompt: Text("Search Location")
                    .fontPoppins(.regular, size: 15)
                    .foregroundStyle(.textTertiary)
            )
            .textFieldStyle(RoundedWithIconTextFieldStyle())
            .padding(.top, 24)
            .padding(.horizontal, 24)
            
            switch viewModel.viewState {
            case .loadedCachedCity:
                if let cityWeather = viewModel.selectedCity {
                    SelectedCityView(viewModel: SelectedCityViewModel(cityWeather: cityWeather))
                } else {
                    NoCitySelectedView()
                }
            case .isSearching, .isLoadingCachedCity:
                ProgressView()
                    .padding(.top, 32)
            case .noSearchResults:
                EmptyView()
            case .loadedSearchResults:
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.searchResults) { cityWeather in
                            CityWeatherSearchResultView(cityWeather: cityWeather)
                            // Allow for bigger cells to show longer names?
                            //                                    .frame(height: 117)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    viewModel.select(cityWeather)
                                }
                        }
                    }
                }
                .contentMargins(.vertical, 32)
                .padding(.horizontal, 20)
                .scrollIndicators(.hidden)
            case .error(let errorMessage, let retryAction):
                ErrorView(errorMessage: errorMessage, retryAction: retryAction)
            }
            
            Spacer()
        }
        .task {
            await viewModel.loadCachedCity()
        }
    }
}
