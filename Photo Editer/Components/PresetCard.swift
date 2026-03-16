//
//  PresetCard.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 13/3/26.
//

import SwiftUI

struct PresetCard: View {
    let item: PresetItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 140)
                
                Text("PRO")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.25))
                    .clipShape(Capsule())
                    .padding(12)
            }
            
            Text(item.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
        }
        .frame(width: 180, alignment: .leading)
    }
}
