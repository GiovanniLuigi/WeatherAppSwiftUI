//
//  RoundedWithIconTextFieldStyle.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 19/12/24.
//
import SwiftUI

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
