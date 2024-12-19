//
//  SelectedCityView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 19/12/24.
//
import SwiftUI

struct SelectedCityView: View {
    let viewModel: SelectedCityViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // TODO: replace with a better image component with cache like Kingfisher
            AsyncImage(url: viewModel.iconURL) { phase in
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
            .frame(width: 200, alignment: .center)
            
            HStack {
                Text(viewModel.cityName)
                    .fontPoppins(.semiBold, size: 30)
                
                Image("temp_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.bottom, 16)
            
            TemperatureView(temperature: viewModel.temperature)
                .padding(.bottom, 24)
            
            HStack {
                makeTitleSubtitleView(title: "Humidity", subtitle: viewModel.humidity)
                Spacer()
                makeTitleSubtitleView(title: "UV", subtitle: viewModel.uv)
                Spacer()
                makeTitleSubtitleView(title: "Feels Like", subtitle: viewModel.feelsLike)
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

struct SelectedCityViewModel {
    private let cityWeather: CityWeather
    
    var temperature: Double {
        cityWeather.weather.temperature
    }
    
    var iconURL: URL? {
        URL(string: cityWeather.weather.condition.iconURL)
    }
    
    var cityName: String {
        cityWeather.city.name
    }
    
    var humidity: String {
        "\(cityWeather.weather.humidity)%"
    }
    
    var uv: String {
        "\(Int(cityWeather.weather.uvIndex))"
    }
    
    var feelsLike: String {
        "\(Int(cityWeather.weather.feelsLikeTemperature))°"
    }
    
    init(cityWeather: CityWeather) {
        self.cityWeather = cityWeather
    }
    
}
