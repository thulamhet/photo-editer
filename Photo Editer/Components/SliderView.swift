//
//  SliderView.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 9/3/26.
//

import SwiftUI

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let onChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(value, specifier: "%.2f")")
            Slider(value: $value, in: range)
                .onChange(of: value) {
                    onChange()
                }
        }
    }
}
