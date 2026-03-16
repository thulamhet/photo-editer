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
    @Published var brightness: Float = 0
    @Published var contrast: Float = 1
    @Published var saturation: Float = 1
    @Published var isRendering = false
    @Published var displayImage: UIImage?
    
    private let originalImage: UIImage
    private let context = CIContext()
    private let renderer = ImageRenderer()
    private var cancellables = Set<AnyCancellable>()
    
    init(image: UIImage) {
        self.originalImage = image
        self.displayImage = image
    }
    
    func scheduleRender() {
        
        renderer.renderPreview(sourceImage: originalImage, adjustments: .init(brightness: brightness, contrast: contrast, saturation: saturation, hue: 0)) { [weak self] image in
            self?.displayImage = image
        }
    }
    
    func sliderEditingChanged(isEditing: Bool) {
        guard !isEditing else { return }
        
        renderer.renderPreview(sourceImage: originalImage, adjustments: .init(brightness: brightness, contrast: contrast, saturation: saturation, hue: 0)) { [weak self] image in
            self?.displayImage = image
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
        displayImage = originalImage
        isRendering = false
    }
}

extension RealPhotoEditorViewModel {
    private func bind() {
        Publishers.CombineLatest3($brightness, $contrast, $saturation)
                    .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
                    .sink { [weak self] brightness, contrast, saturation in
                        guard let self else { return }
                        
                        let adjustments = ImageAdjustments(
                            brightness: brightness,
                            contrast: contrast,
                            saturation: saturation,
                            hue: 0
                        )
                        
                        self.renderer.renderPreview(
                            sourceImage: self.originalImage,
                            adjustments: adjustments
                        ) { [weak self] image in
                            self?.displayImage = image
                        }
                    }
                    .store(in: &cancellables)
    }
}
