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
            backgroundLayer
            
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
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("DARKROOM STUDIO")
                        .font(.caption.weight(.semibold))
                        .tracking(2)
                        .foregroundStyle(VintagePalette.accent)

                    Text("Craft your photos\nlike old film")
                        .font(.system(size: 34, weight: .semibold, design: .serif))
                        .foregroundStyle(VintagePalette.textPrimary)
                        .multilineTextAlignment(.leading)

                    Text("Soft tones, faded prints, and handcrafted edits.")
                        .font(.subheadline)
                        .foregroundStyle(VintagePalette.textSecondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(VintagePalette.cardSoft)
                        .frame(width: 52, height: 52)

                    Circle()
                        .stroke(VintagePalette.stroke, lineWidth: 1)
                        .frame(width: 52, height: 52)

                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(VintagePalette.textPrimary.opacity(0.9))
                }
            }

            Rectangle()
                .fill(VintagePalette.accent.opacity(0.35))
                .frame(width: 96, height: 1)
        }
    }
    
    private var heroSection: some View {
        Button {
            onNavigate(.importPhotos)
        } label: {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                VintagePalette.cardSoft,
                                VintagePalette.olive,
                                VintagePalette.wine
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(VintagePalette.stroke, lineWidth: 1)
                    )
                    .overlay(alignment: .topTrailing) {
                        VStack(alignment: .trailing, spacing: 8) {
                            Text("EST. 2026")
                                .font(.caption2.weight(.semibold))
                                .tracking(1.5)
                            Text("Fine Tone Lab")
                                .font(.caption)
                        }
                        .foregroundStyle(VintagePalette.textSecondary.opacity(0.9))
                        .padding(20)
                    }

                VStack(alignment: .leading, spacing: 16) {
                    Text("NEW SESSION")
                        .font(.caption.weight(.bold))
                        .tracking(2)
                        .foregroundStyle(VintagePalette.accent)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Build a timeless\nphoto look")
                            .font(.system(size: 30, weight: .semibold, design: .serif))
                            .foregroundStyle(VintagePalette.textPrimary)

                        Text("Import a frame, apply warm film-inspired presets, and tune every detail with a softer, analog feel.")
                            .font(.subheadline)
                            .foregroundStyle(VintagePalette.textSecondary)
                            .lineSpacing(3)
                    }

                    HStack(spacing: 12) {
                        Label("Start Edit", systemImage: "plus")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.black.opacity(0.75))
                            .padding(.horizontal, 18)
                            .frame(height: 44)
                            .background(VintagePalette.accent)
                            .clipShape(Capsule())

                        Label("Film Looks", systemImage: "sparkles")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(VintagePalette.textPrimary)
                            .padding(.horizontal, 18)
                            .frame(height: 44)
                            .background(VintagePalette.card.opacity(0.55))
                            .overlay(
                                Capsule()
                                    .stroke(VintagePalette.stroke, lineWidth: 1)
                            )
                    }
                }
                .padding(24)
            }
            .shadow(color: .black.opacity(0.22), radius: 22, y: 12)
        }
        .buttonStyle(.plain)
    }
    
    private var quickToolsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("Quick Tools")
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)], spacing: 14) {
                DashboardToolCard(title: "New Edit", subtitle: "Start from gallery", icon: "plus.square.fill", colors: [VintagePalette.accentSoft, VintagePalette.olive]) {
                    onNavigate(.importPhotos)
                }
                DashboardToolCard(title: "Camera", subtitle: "Shoot & edit instantly", icon: "camera.fill", colors: [VintagePalette.wine, VintagePalette.accentSoft]) {}
                DashboardToolCard(title: "Batch Edit", subtitle: "Apply to many", icon: "square.stack.3d.up.fill", colors: [VintagePalette.olive, VintagePalette.cardSoft]) {}
                DashboardToolCard(title: "Templates", subtitle: "Social-ready layout", icon: "rectangle.on.rectangle.angled.fill", colors: [Color(red: 0.34, green: 0.28, blue: 0.20), VintagePalette.wine]) {}
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
                                    .foregroundStyle(VintagePalette.textPrimary)

                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(VintagePalette.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(VintagePalette.textPrimary.opacity(0.8))
                                .frame(width: 34, height: 34)
                                .background(VintagePalette.cardSoft)
                                .clipShape(Circle())
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(VintagePalette.card.opacity(0.92))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(VintagePalette.stroke, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.16), radius: 14, y: 8)                    }
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
            .font(.system(size: 24, weight: .semibold, design: .serif))
            .foregroundStyle(VintagePalette.textPrimary)
    }
}

#Preview {
    PhotoEditorAppFlowView()
}

private enum VintagePalette {
    static let backgroundTop = Color(red: 0.16, green: 0.13, blue: 0.10)
    static let backgroundBottom = Color(red: 0.07, green: 0.08, blue: 0.06)

    static let card = Color(red: 0.21, green: 0.18, blue: 0.14)
    static let cardSoft = Color(red: 0.27, green: 0.23, blue: 0.18)

    static let accent = Color(red: 0.71, green: 0.58, blue: 0.36)      // gold muted
    static let accentSoft = Color(red: 0.51, green: 0.36, blue: 0.25)  // bronze
    static let wine = Color(red: 0.38, green: 0.20, blue: 0.20)
    static let olive = Color(red: 0.29, green: 0.31, blue: 0.22)

    static let textPrimary = Color(red: 0.96, green: 0.92, blue: 0.84)
    static let textSecondary = Color(red: 0.77, green: 0.72, blue: 0.64)
    static let stroke = Color.white.opacity(0.08)
}

private var backgroundLayer: some View {
    ZStack {
        LinearGradient(
            colors: [
                VintagePalette.backgroundTop,
                Color(red: 0.11, green: 0.10, blue: 0.08),
                VintagePalette.backgroundBottom
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        RadialGradient(
            colors: [
                VintagePalette.accentSoft.opacity(0.18),
                .clear
            ],
            center: .topLeading,
            startRadius: 10,
            endRadius: 380
        )

        RadialGradient(
            colors: [
                VintagePalette.wine.opacity(0.18),
                .clear
            ],
            center: .bottomTrailing,
            startRadius: 20,
            endRadius: 420
        )
    }
    .ignoresSafeArea()
}
