//
//  NoCitySelectedView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 19/12/24.
//
import SwiftUI

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
