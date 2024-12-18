//
//  HomeView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.searchText)
                .padding(8)
                .background(.cardBackground)
                .cornerRadius(10)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    Text("123")
                }
            }
        }
    }
}
