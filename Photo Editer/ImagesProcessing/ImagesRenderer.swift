//
//  ImagesRenderer.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 12/3/26.
//

import UIKit
import CoreImage

final class ImageRenderer {
    
    private let context = CIContext(options: [
        .useSoftwareRenderer: false
    ])
    
    private var previewTask: Task<Void, Never>?
    private var fullTask: Task<Void, Never>?
    
    private var cachedFullCIImage: CIImage?
    private var cachedPreviewCIImage: CIImage?
    private var cachedImageIdentifier: ObjectIdentifier?
    private let colorControlsFilter = CIFilter(name: "CIColorControls")!
    
    func prepareImages(from sourceImage: UIImage) {
        let identifier = ObjectIdentifier(sourceImage)
        guard cachedImageIdentifier != identifier else { return }
        cachedImageIdentifier = identifier
        
        guard let cg = sourceImage.cgImage else {
            cachedFullCIImage = nil
            cachedPreviewCIImage = nil
            return
        }
        
        let full = CIImage(cgImage: cg)
        cachedFullCIImage = full
        cachedPreviewCIImage = downscaledImage(from: full, maxDim: 1000)
    }
    
    func renderPreview(
        sourceImage: UIImage,
        adjustments: ImageAdjustments,
        completion: @escaping (UIImage?) -> Void
    ) {
        prepareImages(from: sourceImage)
        previewTask?.cancel()
        
        let inputImage = cachedPreviewCIImage
        
        previewTask = Task(priority: .userInitiated) { [weak self] in
            guard let self, let inputImage else { return }
            guard !Task.isCancelled else { return }
            
            let result = self.applyAdjustments(
                to: inputImage,
                adjustments: adjustments
            )
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                completion(result)
            }
        }
    }
    
    func renderFullQuality(
        sourceImage: UIImage,
        adjustments: ImageAdjustments,
        completion: @escaping (UIImage?) -> Void
    ) {
        prepareImages(from: sourceImage)
        fullTask?.cancel()
        
        let inputImage = cachedFullCIImage
        
        fullTask = Task(priority: .userInitiated) { [weak self] in
            guard let self, let inputImage else { return }
            guard !Task.isCancelled else { return }
            
            let result = self.applyAdjustments(
                to: inputImage,
                adjustments: adjustments
            )
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                completion(result)
            }
        }
    }
    
    private func applyAdjustments(
        to image: CIImage,
        adjustments: ImageAdjustments
    ) -> UIImage? {
        let filter = colorControlsFilter
        filter.setDefaults()
        
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(adjustments.brightness, forKey: kCIInputBrightnessKey)
        filter.setValue(adjustments.contrast, forKey: kCIInputContrastKey)
        filter.setValue(adjustments.saturation, forKey: kCIInputSaturationKey)
        
        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func downscaledImage(from image: CIImage, maxDim: CGFloat) -> CIImage {
        let w = image.extent.width
        let h = image.extent.height
        let scale = min(maxDim / max(w, h), 1.0)
        
        guard scale < 1.0,
              let lanczos = CIFilter(name: "CILanczosScaleTransform") else {
            return image
        }
        
        lanczos.setValue(image, forKey: kCIInputImageKey)
        lanczos.setValue(scale, forKey: kCIInputScaleKey)
        lanczos.setValue(1.0, forKey: kCIInputAspectRatioKey)
        
        return lanczos.outputImage ?? image
    }
}
