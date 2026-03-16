//
//  EditorSlideRow.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 13/3/26.
//

import SwiftUI

struct EditorSliderRow: View {
    let title: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Text(value.formatted(.number.precision(.fractionLength(2))))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
            Slider(value: $value, in: range)
                .tint(.white)
        }
    }
}
