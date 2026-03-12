//
//  RealPhotoEditorViewModel.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 12/3/26.
//

import SwiftUI
import Combine

@MainActor
final class RealPhotoEditorViewModel: ObservableObject {
    @Published var brightness: Double = 0
    @Published var contrast: Double = 1
    @Published var saturation: Double = 1
    @Published var previewImage: UIImage
    @Published var isRendering = false
    
    private let originalImage: UIImage
    private let context = CIContext()
    private var renderTask: Task<Void, Never>?
    
    init(image: UIImage) {
        self.originalImage = image
        self.previewImage = image
    }
    
    func scheduleRender() {
        renderTask?.cancel()
        
        let brightness = brightness
        let contrast = contrast
        let saturation = saturation
        let originalImage = originalImage
        let context = context
        
        isRendering = true
        
        renderTask = Task.detached(priority: .userInitiated) { [weak self] in
            try? await Task.sleep(for: .milliseconds(60))
            guard !Task.isCancelled else { return }
            
            let renderedImage = Self.render(
                image: originalImage,
                brightness: brightness,
                contrast: contrast,
                saturation: saturation,
                context: context
            ) ?? originalImage
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                self?.previewImage = renderedImage
                self?.isRendering = false
            }
        }
    }
    
    func applyPreset(_ preset: String) {
        switch preset {
        case "Cinematic":
            brightness = -0.05
            contrast = 1.25
            saturation = 0.95
            
        case "Vintage":
            brightness = 0.10
            contrast = 0.90
            saturation = 0.80
            
        case "Bright":
            brightness = 0.18
            contrast = 1.05
            saturation = 1.18
            
        case "Moody":
            brightness = -0.20
            contrast = 1.20
            saturation = 0.88
            
        default:
            brightness = 0
            contrast = 1
            saturation = 1
        }
        
        scheduleRender()
    }
    
    func reset() {
        brightness = 0
        contrast = 1
        saturation = 1
        previewImage = originalImage
        renderTask?.cancel()
        isRendering = false
    }
    
    nonisolated private static func render(
        image: UIImage,
        brightness: Double,
        contrast: Double,
        saturation: Double,
        context: CIContext
    ) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = Float(brightness)
        filter.contrast = Float(contrast)
        filter.saturation = Float(saturation)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
    }
}

