//
//  DashboardView.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI

struct PhotoEditorAppFlowView: View {
    @Namespace private var namespace
    @State private var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            DashboardScreen(namespace: namespace) { route in
                path.append(route)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .importPhotos:
                        ImportScreen(namespace: namespace) { selected in
                            path.append(.editor(selected))
                        } onImportedPhoto: { photo in
                            path.append(.realEditor(photo))
                        }
                case .editor(let item):
                    EditorScreen(item: item, namespace: namespace)
                    case .realEditor(let photo):
                        RealPhotoEditorScreen(photo: photo)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Routes
struct EditablePhoto: Hashable {
    let id = UUID()
    let title: String
    let imageData: Data
    
    var image: UIImage {
        UIImage(data: imageData) ?? UIImage()
    }
}
enum Route: Hashable {
    case importPhotos
    case editor(GalleryItem)
    case realEditor(EditablePhoto)
}

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
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white.opacity(0.55))
                TextField("Search projects, presets...", text: $searchText)
                    .textFieldStyle(.plain)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.white.opacity(0.07))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(.white.opacity(0.06), lineWidth: 1)
            )
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
                        onNavigate(.editor(item))
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

// MARK: - Import Screen



// MARK: - Editor Screen

struct EditorScreen: View {
    let item: GalleryItem
    let namespace: Namespace.ID
    
    @State private var brightness: Double = 0.05
    @State private var contrast: Double = 1.05
    @State private var saturation: Double = 1.0
    @State private var selectedPreset: String = "Original"
    
    private let presetNames = ["Original", "Cinematic", "Vintage", "Bright", "Moody"]
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    imagePreviewSection
                    presetsSection
                    controlsSection
                    exportSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onChange(of: selectedPreset) { _, newValue in
            applyPreset(newValue)
        }
    }
    
    private var imagePreviewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Fine tune your image")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                Spacer()
                Label("HD", systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.08))
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
            }
            
            ZStack(alignment: .bottom) {
                GalleryThumb(item: item)
                    .matchedGeometryEffect(id: item.id, in: namespace)
                    .frame(height: 430)
                    .overlay {
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.15), .black.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                
                HStack(spacing: 10) {
                    infoChip(title: "Bri", value: brightness.formatted(.number.precision(.fractionLength(2))))
                    infoChip(title: "Con", value: contrast.formatted(.number.precision(.fractionLength(2))))
                    infoChip(title: "Sat", value: saturation.formatted(.number.precision(.fractionLength(2))))
                }
                .padding(14)
            }
        }
    }
    
    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Presets")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(presetNames, id: \.self) { preset in
                        Button {
                            selectedPreset = preset
                        } label: {
                            Text(preset)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(selectedPreset == preset ? .black : .white)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(selectedPreset == preset ? .white : .white.opacity(0.08))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    private var controlsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Adjustments")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            
            VStack(spacing: 16) {
                EditorSliderRow(title: "Brightness", value: $brightness, range: -1...1)
                EditorSliderRow(title: "Contrast", value: $contrast, range: 0.5...2)
                EditorSliderRow(title: "Saturation", value: $saturation, range: 0...2)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.05), lineWidth: 1)
            )
        }
    }
    
    private var exportSection: some View {
        VStack(spacing: 14) {
            Button {
                // export action
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Export in HD")
                        .fontWeight(.bold)
                }
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .buttonStyle(.plain)
            
            Button {
                brightness = 0.05
                contrast = 1.05
                saturation = 1.0
                selectedPreset = "Original"
            } label: {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                    Text("Reset adjustments")
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            }
            .buttonStyle(.plain)
        }
    }
    
    private func infoChip(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.black.opacity(0.35))
        .clipShape(Capsule())
    }
    
    private func applyPreset(_ preset: String) {
        switch preset {
        case "Cinematic":
            brightness = -0.05
            contrast = 1.25
            saturation = 0.95
        case "Vintage":
            brightness = 0.08
            contrast = 0.92
            saturation = 0.82
        case "Bright":
            brightness = 0.18
            contrast = 1.05
            saturation = 1.15
        case "Moody":
            brightness = -0.18
            contrast = 1.18
            saturation = 0.88
        default:
            brightness = 0.05
            contrast = 1.05
            saturation = 1.0
        }
    }
}

// MARK: - Shared Components


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

struct EditorSliderRow: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
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

// MARK: - Models

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

struct PresetItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

#Preview {
    PhotoEditorAppFlowView()
}
