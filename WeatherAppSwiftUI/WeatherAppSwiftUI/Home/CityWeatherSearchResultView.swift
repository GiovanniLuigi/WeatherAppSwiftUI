//
//  CitySearchResultView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import SwiftUI

struct CityWeatherSearchResultView: View {
    let cityWeather: CityWeather
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                Text(cityWeather.city.name)
                    .fontPoppins(.semiBold, size: 20)
                
                TemperatureView(temperature: cityWeather.weather.temperature)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .foregroundStyle(.textPrimary)
        .background(Color.cardBackground)
        .clipShape(.rect(cornerRadius: 16))
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    CityWeatherSearchResultView(
        cityWeather: CityWeather(
            city: City(id: 290762, name: "Sao Paulo De Olivenca"),
            weather: Weather(
                temperature: 26.3,
                condition: WeatherCondition(
                    text: "Patchy rain nearby",
                    iconURL: "https://cdn.weatherapi.com/weather/64x64/day/176.png"
                ),
                humidity: 83,
                uvIndex: 9.8,
                feelsLikeTemperature: 29.3
            )
        )
    )
    .padding(.horizontal, 20)
    .frame(height: 117)
}
