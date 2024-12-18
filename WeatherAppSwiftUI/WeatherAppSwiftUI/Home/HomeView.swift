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
                    .foregroundStyle(.customLightGray)
            )
                .textFieldStyle(RoundedWithIconTextFieldStyle())
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                switch viewModel.viewState {
                case .isLoadingCachedCity:
                    Text("To implement first load")
                case .loadedCachedCity:
                    if let city = viewModel.selectedCity {
                        Text("Fetch current weather")
                    } else {
                        NoCitySelectedView()
                    }
                case .isSearching:
                    Text("Searching")
                case .noSearchResults:
                    Text("Nothing found")
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
            Text("Please earch For A City")
            
            Spacer()
            Spacer()
            Spacer()
        }
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
            Color(UIColor.cardBackground)
        )
        .clipShape(.rect(cornerRadius: 16))
        .focused($focused)
        .onTapGesture {
            focused = true
        }
    }
}
