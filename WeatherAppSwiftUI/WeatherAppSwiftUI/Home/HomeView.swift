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
        VStack {
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
                    if let city = viewModel.selectedCity {
                        Text("Found: \(city.city.name)")
                    } else {
                        NoCitySelectedView()
                    }
                case .isSearching:
                    Text("Searching")
                case .noSearchResults:
                    EmptyView()
                case .loadedSearchResults:
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.searchResults) { cityWeather in
                                Text(cityWeather.city.name)
                            }
                        }
                    }
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
