//
//  PoppinsFontModifier.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//

import SwiftUI

enum PoppinsFontWeight: String {
    case regular = "Poppins-Regular"
    case bold = "Poppins-Bold"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
}

struct PoppinsFontModifier: ViewModifier {
    let weight: PoppinsFontWeight
    let size: CGFloat

    func body(content: Content) -> some View {
        content.font(.custom(weight.rawValue, size: size))
    }
}

extension View {
    func fontPoppins(_ weight: PoppinsFontWeight, size: CGFloat) -> some View {
        self.modifier(PoppinsFontModifier(weight: weight, size: size))
    }
}

extension Text {
    func fontPoppins(_ weight: PoppinsFontWeight, size: CGFloat) -> Text {
        self.font(.custom(weight.rawValue, size: size))
    }
}

