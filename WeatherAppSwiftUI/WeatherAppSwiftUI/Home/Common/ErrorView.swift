//
//  ErrorView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 19/12/24.
//
import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("An Error ocurred!")
                .fontPoppins(.semiBold, size: 30)
            
            Text(errorMessage)
            
            Button("Retry") { retryAction() }
                .fontPoppins(.semiBold, size: 15)
                .padding(.top, 24)
            
            Spacer()
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        
    }
}
