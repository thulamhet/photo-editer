//
//  DashboardView.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI

// MARK: - Dashboard

struct DashboardScreen: View {
    let namespace: Namespace.ID
    let onNavigate: (Route) -> Void
    @State private var searchText = ""
    
    private let recentProjects: [GalleryItem] = GalleryItem.samples
    private let presets: [PresetItem] = [
        .init(title: "Cinematic", subtitle: "Deep contrast"),
        .init(title: "Vintage", subtitle: "Warm faded tone"),
        .init(title: "Clean Pro", subtitle: "Sharp & bright"),
        .init(title: "Dreamy", subtitle: "Soft pastel feel")
    ]
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    heroSection
                    quickToolsSection
                    recentProjectsSection
                    presetsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome back")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.68))
                    
                    Text("Edit like an artist")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.white.opacity(0.95))
                }
            }
        }
    }
    
    private var heroSection: some View {
        Button {
            onNavigate(.importPhotos)
        } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.22, green: 0.15, blue: 0.42),
                                Color(red: 0.08, green: 0.10, blue: 0.18),
                                Color(red: 0.42, green: 0.16, blue: 0.20)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 290)
                    .overlay(alignment: .topTrailing) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.08))
                                .frame(width: 180, height: 180)
                                .offset(x: 30, y: -20)
                            Circle()
                                .fill(.white.opacity(0.06))
                                .frame(width: 110, height: 110)
                                .offset(x: -10, y: 45)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("START NEW PROJECT")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Turn your photos into something cinematic")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("Import from gallery, apply premium presets, and fine-tune brightness, contrast, and saturation.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    HStack(spacing: 12) {
                        Label("New Edit", systemImage: "plus")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 18)
                            .frame(height: 46)
                            .background(.white)
                            .clipShape(Capsule())
                        
                        Label("AI Enhance", systemImage: "sparkles")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .frame(height: 46)
                            .background(.white.opacity(0.08))
                            .clipShape(Capsule())
                    }
                }
                .padding(24)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Quick Tools")
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                DashboardToolCard(title: "New Edit", subtitle: "Start from gallery", icon: "plus.square.fill", colors: [.purple, .blue]) {
                    onNavigate(.importPhotos)
                }
                DashboardToolCard(title: "Camera", subtitle: "Shoot & edit instantly", icon: "camera.fill", colors: [.orange, .pink]) {}
                DashboardToolCard(title: "Batch Edit", subtitle: "Apply to many", icon: "square.stack.3d.up.fill", colors: [.green, .teal]) {}
                DashboardToolCard(title: "Templates", subtitle: "Social-ready layout", icon: "rectangle.on.rectangle.angled.fill", colors: [.indigo, .cyan]) {}
            }
        }
    }
    
    private var recentProjectsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                sectionTitle("Recent Projects")
                Spacer()
                Text("See all")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            VStack(spacing: 12) {
                ForEach(recentProjects) { item in
                    Button {
//                        onNavigate(.editor(item))
                    } label: {
                        HStack(spacing: 14) {
                            GalleryThumb(item: item)
                                .matchedGeometryEffect(id: item.id, in: namespace)
                                .frame(width: 72, height: 72)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.65))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white.opacity(0.7))
                                .frame(width: 34, height: 34)
                                .background(.white.opacity(0.07))
                                .clipShape(Circle())
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.06), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                sectionTitle("Featured Presets")
                Spacer()
                Text("Explore")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(presets) { item in
                        PresetCard(item: item)
                    }
                }
            }
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.title3.weight(.bold))
            .foregroundStyle(.white)
    }
}

#Preview {
    PhotoEditorAppFlowView()
}
