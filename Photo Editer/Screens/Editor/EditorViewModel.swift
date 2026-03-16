import SwiftUI
import CoreImage
import UIKit
import Combine

@MainActor
final class PhotoEditorViewModel: ObservableObject {
    
    @Published var displayImage: UIImage?
    @Published var brightness: Double = 0
    
    private let renderer = ImageRenderer()
    
    private var originalImage: UIImage?
    private var previewImage: UIImage?
    
    func setImage(_ image: UIImage) {
        let normalizedImage = image.normalized()
        
        originalImage = normalizedImage
        previewImage = normalizedImage.resizedToFit(maxPixel: 1200)
        displayImage = previewImage
        brightness = 0
    }
    
    func reset() {
        brightness = 0
        displayImage = previewImage
    }
    
    func sliderChanged(to newValue: Double) {
        brightness = newValue
        
        guard let previewImage else { return }
        
//        renderer.renderPreview(
//            sourceImage: previewImage,
//            brightness: Float(newValue)
//        ) { [weak self] image in
//            self?.displayImage = image
//        }
    }
    
    func sliderEditingChanged(isEditing: Bool) {
        guard !isEditing else { return }
        guard let originalImage else { return }
        
//        renderer.renderFullQuality(
//            sourceImage: originalImage,
//            brightness: Float(brightness)
//        ) { [weak self] image in
//            self?.displayImage = image
//        }
    }
}
