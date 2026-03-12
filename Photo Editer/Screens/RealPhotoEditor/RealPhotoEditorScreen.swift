//
//  RealPhotoEditorScreen.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct RealPhotoEditorScreen: View {
    let photo: EditablePhoto
    
    @StateObject private var viewModel: RealPhotoEditorViewModel
    @State private var selectedPreset = "Original"
    @State private var showSaveAlert = false
    @State private var saveMessage = ""
    
    init(photo: EditablePhoto) {
        self.photo = photo
        _viewModel = StateObject(
            wrappedValue: RealPhotoEditorViewModel(image: photo.image)
        )
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    previewSection
                    presetSection
                    adjustmentSection
                    actionSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Real Editor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Saved", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveMessage)
        }
        .onChange(of: selectedPreset) { _, newValue in
            viewModel.applyPreset(newValue)
        }
        .onChange(of: viewModel.brightness) { _, _ in
            viewModel.scheduleRender()
        }
        .onChange(of: viewModel.contrast) { _, _ in
            viewModel.scheduleRender()
        }
        .onChange(of: viewModel.saturation) { _, _ in
            viewModel.scheduleRender()
        }
    }
    
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(photo.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                    
                    Text("Edit a real image from your photo library")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Spacer()
                
                if viewModel.isRendering {
                    ProgressView()
                        .tint(.white)
                }
            }
            
            ZStack(alignment: .bottom) {
                Image(uiImage: viewModel.previewImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 440)
                    .background(.black.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                
                HStack(spacing: 10) {
                    infoChip(title: "Bri", value: viewModel.brightness.formatted(.number.precision(.fractionLength(2))))
                    infoChip(title: "Con", value: viewModel.contrast.formatted(.number.precision(.fractionLength(2))))
                    infoChip(title: "Sat", value: viewModel.saturation.formatted(.number.precision(.fractionLength(2))))
                }
                .padding(14)
            }
        }
    }
    
    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Presets")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(["Original", "Cinematic", "Vintage", "Bright", "Moody"], id: \.self) { preset in
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
    
    private var adjustmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Adjustments")
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            
            VStack(spacing: 16) {
                EditorSliderRow(
                    title: "Brightness",
                    value: $viewModel.brightness,
                    range: -1...1
                )
                
                EditorSliderRow(
                    title: "Contrast",
                    value: $viewModel.contrast,
                    range: 0.5...2
                )
                
                EditorSliderRow(
                    title: "Saturation",
                    value: $viewModel.saturation,
                    range: 0...2
                )
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
    
    private var actionSection: some View {
        VStack(spacing: 14) {
            Button {
                saveImage()
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down.fill")
                    Text("Save to Photos")
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
                selectedPreset = "Original"
                viewModel.reset()
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
    
    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(viewModel.previewImage, nil, nil, nil)
        saveMessage = "Your edited image has been saved to Photos."
        showSaveAlert = true
    }
}
