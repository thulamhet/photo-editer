//
//  EditorViewModel.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 9/3/26.
//

import Combine
import SwiftUI

@MainActor
final class EditorViewModel: ObservableObject {
    
    @Published var inputImage: UIImage?
    @Published var outputImage: UIImage?
    @Published var brightness: Double = 0
    @Published var contrast: Double = 1
    @Published var saturation: Double = 1
    
    private let filterTrigger = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    private let context = CIContext()
    private let queue = DispatchQueue(label: "image.processing.queue", qos: .userInteractive)
    private let brightnessFilter = CIFilter.colorControls()
    
    init() {
        filterTrigger
            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    func scheduleApplyFilters() {
        filterTrigger.send(())
    }
    
    func applyFilters() {
        guard let inputImage,
              let ciImage = CIImage(image: inputImage) else { return }
        
        brightnessFilter.inputImage = ciImage
        brightnessFilter.brightness = Float(brightness)
        brightnessFilter.contrast = Float(contrast)
        brightnessFilter.saturation = Float(saturation)
        
        guard let outputCIImage = brightnessFilter.outputImage else { return }
        
        queue.async {
            if let cgImage = self.context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    self.outputImage = uiImage
                }
            }
        }
    }
    
    func reset() {
        brightness = 0
        contrast = 1
        saturation = 1
        applyFilters()
    }
}
