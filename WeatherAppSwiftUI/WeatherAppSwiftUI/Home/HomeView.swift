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
            case .isLoadingCachedCity:
                Text("To implement first load")
            case .loadedCachedCity:
                if let cityWeather = viewModel.selectedCity {
                    SelectedCityView(cityWeather: cityWeather)
                } else {
                    NoCitySelectedView()
                }
            case .isSearching:
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
            case .error:
                Text("Error")
            }
            
            Spacer()
        }
        .task {
            await viewModel.loadCachedCity()
        }
    }
}

struct SelectedCityView: View {
    let cityWeather: CityWeather
    // TODO: - add pull to refresh
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            AsyncImage(url: URL(string: cityWeather.weather.condition.iconURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    ProgressView()
                }
            }
            .padding(.horizontal, 48)
            .frame(width: 200, height: 200, alignment: .center)
            
            HStack {
                Text(cityWeather.city.name)
                    .fontPoppins(.semiBold, size: 30)
            }
            .padding(.bottom, 16)
            .padding(.top, 8)
            
            TemperatureView(temperature: cityWeather.weather.temperature)
                .padding(.bottom, 24)
            
            HStack {
                makeTitleSubtitleView(title: "Humidity", subtitle: "\(cityWeather.weather.humidity)")
                Spacer()
                makeTitleSubtitleView(title: "UV", subtitle: "\(cityWeather.weather.uvIndex)")
                Spacer()
                makeTitleSubtitleView(title: "Feels Like", subtitle: "\(cityWeather.weather.feelsLikeTemperature)°")
            }
            .padding(16)
            .frame(maxWidth: 290, alignment: .center)
            .background(Color.cardBackground)
            .clipShape(.rect(cornerRadius: 16))
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    @ViewBuilder
    private func makeTitleSubtitleView(title: String, subtitle: String) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .fontPoppins(.medium, size: 12)
                .foregroundStyle(.textTertiary)
            
            Text(subtitle)
                .fontPoppins(.medium, size: 15)
                .foregroundStyle(.textSecondary)
        }
    }
}

struct NoCitySelectedView: View {
    // TODO: do the math and use a geometry reader to get the exact proportion and replace these spacers
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("No City Selected")
                .fontPoppins(.semiBold, size: 30)
            
            Text("Please earch For A City")
                .fontPoppins(.semiBold, size: 15)
            
            Spacer()
            Spacer()
            Spacer()
        }
        .foregroundStyle(.textPrimary)
    }
}

struct RoundedWithIconTextFieldStyle: TextFieldStyle {
    // Tapping on the background color also triggers the keyboard
    // TODO: - tap outside to dismiss
    @FocusState private var focused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack {
            configuration
            Spacer()
            Image("search_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 17)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            Color(.cardBackground)
        )
        .clipShape(.rect(cornerRadius: 16))
        .focused($focused)
        .onTapGesture {
            focused = true
        }
        .tint(.textPrimary)
        .foregroundStyle(.textPrimary)
        .fontPoppins(.regular, size: 15)
    }
}
