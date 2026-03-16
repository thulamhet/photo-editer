//
//  GalleryThumb.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 13/3/26.
//

import SwiftUI

struct GalleryThumb: View {
    let item: GalleryItem
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(item.gradient)
            .overlay(alignment: .bottomLeading) {
                LinearGradient(colors: [.clear, .black.opacity(0.2), .black.opacity(0.45)], startPoint: .top, endPoint: .bottom)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .overlay(alignment: .center) {
                Image(systemName: item.icon)
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.96))
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
