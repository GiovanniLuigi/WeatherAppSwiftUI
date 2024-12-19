//
//  TemperatureView.swift
//  WeatherAppSwiftUI
//
//  Created by Giovanni Bruno on 18/12/24.
//
import SwiftUI

struct TemperatureView: View {
    let temperature: Double
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("\(Int(temperature))")
                .fontPoppins(.semiBold, size: 60)
                .alignmentGuide(.top) { d in d[.firstTextBaseline] - d.height * 0.5 }
            
            Circle()
                .stroke(Color.black, lineWidth: 1)
                .frame(width: 5, height: 5)
        }
    }
}
