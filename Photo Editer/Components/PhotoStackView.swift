//
//  PhotoStackView.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI

struct PhotoStackView: View {
    let backLeftImage: String
    let backRightImage: String
    let frontImage: String
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.9, blue: 0.86)
                .ignoresSafeArea()
            
            ZStack(alignment: .bottom) {
                photoCard(imageName: backLeftImage)
                    .frame(width: 230, height: 230)
                    .rotationEffect(.degrees(-8))
                    .offset(x: -35, y: -70)
                    .zIndex(0)
                
                photoCard(imageName: backRightImage)
                    .frame(width: 230, height: 450)
                    .rotationEffect(.degrees(8))
                    .offset(x: 30, y: -20)
                    .zIndex(1)
                
                photoCard(imageName: frontImage)
                    .frame(width: 230, height: 400)
                    .offset(y: 90)
                    .zIndex(3)
            }
        }
    }
    
    private func photoCard(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .clipShape(Rectangle())
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: 12)
            )
            .clipped()
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
    
    private var bottomCard: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    Text("ADD NEW\nPHOTO")
                        .font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 42, height: 42)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        // small crop marks feeling
                        Group {
                            cornerMark(top: true, leading: true)
                            cornerMark(top: true, leading: false)
                            cornerMark(top: false, leading: true)
                            cornerMark(top: false, leading: false)
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 26)
            }
        }
    }
    
    @ViewBuilder
    private func cornerMark(top: Bool, leading: Bool) -> some View {
        VStack {
            if top {
                HStack {
                    if leading {
                        Rectangle().frame(width: 10, height: 2)
                        Spacer()
                    } else {
                        Spacer()
                        Rectangle().frame(width: 10, height: 2)
                    }
                }
                
                Spacer()
            } else {
                Spacer()
                
                HStack {
                    if leading {
                        Rectangle().frame(width: 10, height: 2)
                        Spacer()
                    } else {
                        Spacer()
                        Rectangle().frame(width: 10, height: 2)
                    }
                }
            }
        }
        .frame(width: 42, height: 42)
        .overlay(
            HStack {
                if leading {
                    Rectangle().frame(width: 2, height: 10)
                    Spacer()
                } else {
                    Spacer()
                    Rectangle().frame(width: 2, height: 10)
                }
            }
            .padding(.vertical, top ? 0 : 32)
        )
        .foregroundColor(.white)
    }
}

#Preview {
    PhotoStackView(
        backLeftImage: "paint1",
        backRightImage: "paint3",
        frontImage: "paint4"
    )
}
