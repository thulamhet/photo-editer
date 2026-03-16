//
//  DashboardToolCard.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI

struct DashboardToolCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 132)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.black.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.18))
                            .frame(width: 42, height: 42)
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
//                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.82))
                    }
                }
                .padding(16)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
        DashboardToolCard(title: "New Edit", subtitle: "Start from gallery", icon: "plus.square.fill", colors: [.purple, .blue]) {}
        DashboardToolCard(title: "Camera", subtitle: "Shoot & edit instantly", icon: "camera.fill", colors: [.orange, .pink]) {}
        DashboardToolCard(title: "Batch Edit", subtitle: "Apply to many", icon: "square.stack.3d.up.fill", colors: [.green, .teal]) {}
        DashboardToolCard(title: "Templates", subtitle: "Social-ready layout", icon: "rectangle.on.rectangle.angled.fill", colors: [.indigo, .cyan]) {}
    }
}
