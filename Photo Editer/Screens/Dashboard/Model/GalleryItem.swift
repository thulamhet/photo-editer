//
//  GalleryItem.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 13/3/26.
//

import SwiftUI

struct GalleryItem: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    
    var gradient: LinearGradient {
        LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    static let samples: [GalleryItem] = [
        .init(title: "Neon Street", subtitle: "Edited 2h ago", icon: "sparkles.tv", colors: [.purple, .blue, .black]),
        .init(title: "Golden Portrait", subtitle: "Edited yesterday", icon: "person.crop.square", colors: [.orange, .pink, .red]),
        .init(title: "Ocean Air", subtitle: "Edited 3d ago", icon: "water.waves", colors: [.cyan, .blue, .indigo])
    ]
    
    static let moreSamples: [GalleryItem] = [
        .init(title: "Urban Noise", subtitle: "Tap to edit", icon: "building.2.crop.circle", colors: [.gray, .black, .indigo]),
        .init(title: "Soft Bloom", subtitle: "Tap to edit", icon: "camera.macro", colors: [.pink, .purple, .mint]),
        .init(title: "Night Drive", subtitle: "Tap to edit", icon: "car.fill", colors: [.orange, .purple, .black]),
        .init(title: "Sunny Day", subtitle: "Tap to edit", icon: "sun.max.fill", colors: [.yellow, .orange, .pink]),
        .init(title: "Forest Calm", subtitle: "Tap to edit", icon: "leaf.fill", colors: [.green, .teal, .indigo])
    ]
}

