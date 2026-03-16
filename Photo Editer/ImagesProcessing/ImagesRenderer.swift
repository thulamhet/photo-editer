//
//  ImagesRenderer.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 12/3/26.
//

import UIKit

final class ImageRenderer {
    
    private let context = CIContext(options: [
        .useSoftwareRenderer: false
    ])
    
    private var previewTask: Task<Void, Never>?
    private var fullTask: Task<Void, Never>?
    
    func renderPreview(
        sourceImage: UIImage,
        adjustments: ImageAdjustments,
        completion: @escaping (UIImage?) -> Void
    ) {
        previewTask?.cancel()
        
        previewTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            let result = self.applyAdjustments(
                to: sourceImage,
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
        fullTask?.cancel()
        
        fullTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            let result = self.applyAdjustments(
                to: sourceImage,
                adjustments: adjustments
            )
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                completion(result)
            }
        }
    }
    
    private func applyAdjustments(
        to image: UIImage,
        adjustments: ImageAdjustments
    ) -> UIImage? {
        
        guard let ciImage = CIImage(image: image),
              let filter = CIFilter(name: "CIColorControls") else {
            return nil
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(adjustments.brightness, forKey: kCIInputBrightnessKey)
        filter.setValue(adjustments.contrast, forKey: kCIInputContrastKey)
        filter.setValue(adjustments.saturation, forKey: kCIInputSaturationKey)
        
        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

