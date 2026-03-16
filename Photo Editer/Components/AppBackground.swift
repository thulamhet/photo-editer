//
//  AppBackground.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.06, blue: 0.11),
                Color(red: 0.09, green: 0.08, blue: 0.15),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.16))
                    .frame(width: 260, height: 260)
                    .blur(radius: 70)
                    .offset(x: -120, y: -20)
                Circle()
                    .fill(Color.orange.opacity(0.12))
                    .frame(width: 240, height: 240)
                    .blur(radius: 70)
                    .offset(x: 140, y: 40)
            }
        }
    }
}

//#Preview {
//    AppBackground()
//}
