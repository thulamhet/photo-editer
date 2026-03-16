//
//  ImportScreen.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI
import PhotosUI

struct ImportScreen: View {
    let namespace: Namespace.ID
    let onSelect: (GalleryItem) -> Void
    let onImportedPhoto: (EditablePhoto) -> Void
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var isLoadingPhoto = false
    @State private var importError: String?
    
    private let items = GalleryItem.samples + GalleryItem.moreSamples
    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Import Photo")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Pick a real photo from your library, or use demo items below.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    
                    importCTA
                    
                    if let importError {
                        Text(importError)
                            .font(.footnote)
                            .foregroundStyle(.red.opacity(0.9))
                    }
                    
                    Text("Demo Gallery")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(items) { item in
                            Button {
                                onSelect(item)
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    GalleryThumb(item: item)
                                        .matchedGeometryEffect(id: item.id, in: namespace)
                                        .frame(height: 190)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.title)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(item.subtitle)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.65))
                                    }
                                    .padding(.horizontal, 4)
                                    .padding(.bottom, 2)
                                }
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .fill(.white.opacity(0.06))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                                        .stroke(.white.opacity(0.05), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onChange(of: selectedPhotoItem) { _, newValue in
            guard let newValue else { return }
            Task {
                await loadRealPhoto(from: newValue)
            }
        }
    }
    
    private var importCTA: some View {
        PhotosPicker(
            selection: $selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.07))
                .frame(height: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.06), lineWidth: 1)
                )
                .overlay {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.purple, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 74, height: 74)
                            
                            Image(systemName: isLoadingPhoto ? "hourglass" : "photo.stack.fill")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Import from Library")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.white)
                            
                            Text("Choose a real image from Photos.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.72))
                        }
                        
                        Spacer()
                    }
                    .padding(20)
                }
        }
    }
    
    @MainActor
    private func loadRealPhoto(from item: PhotosPickerItem) async {
        isLoadingPhoto = true
        importError = nil
        defer { isLoadingPhoto = false }
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self) else {
                importError = "Không đọc được dữ liệu ảnh."
                return
            }
            
            guard let image = UIImage(data: data) else {
                importError = "File chọn vào không phải ảnh hợp lệ."
                return
            }
            
            let normalized = image.normalized()
            guard let normalizedData = normalized.jpegData(compressionQuality: 1.0) else {
                importError = "Không convert được ảnh."
                return
            }
            
            let photo = EditablePhoto(
                title: "Imported Photo",
                imageData: normalizedData
            )
            
            onImportedPhoto(photo)
        } catch {
            importError = error.localizedDescription
        }
    }
}

struct RealPhotoPreviewScreen: View {
    let photo: EditablePhoto
    
    var body: some View {
        ZStack {
            AppBackground()
            
            VStack(spacing: 20) {
                Text(photo.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Image(uiImage: photo.image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .navigationTitle("Real Photo")
        .navigationBarTitleDisplayMode(.inline)
    }
}
