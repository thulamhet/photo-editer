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
        brightness: Float,
        completion: @escaping (UIImage?) -> Void
    ) {
        previewTask?.cancel()
        
        previewTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            let result = self.applyBrightness(
                to: sourceImage,
                brightness: brightness
            )
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                completion(result)
            }
        }
    }
    
    func renderFullQuality(
        sourceImage: UIImage,
        brightness: Float,
        completion: @escaping (UIImage?) -> Void
    ) {
        fullTask?.cancel()
        
        fullTask = Task(priority: .userInitiated) { [weak self] in
            guard let self else { return }
            
            let result = self.applyBrightness(
                to: sourceImage,
                brightness: brightness
            )
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                completion(result)
            }
        }
    }
    
    private func applyBrightness(
        to image: UIImage,
        brightness: Float
    ) -> UIImage? {
        
        guard let ciImage = CIImage(image: image),
              let filter = CIFilter(name: "CIColorControls") else {
            return nil
        }

        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(brightness, forKey: kCIInputBrightnessKey)

        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

