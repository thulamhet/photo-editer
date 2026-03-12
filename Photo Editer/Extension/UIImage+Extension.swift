//
//  UIImage+Extension.swift
//  Photo Editer
//
//  Created by Thu. Nguyen Cong on 12/3/26.
//

import UIKit

extension UIImage {
    func normalized() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func resizedToFit(maxPixel: CGFloat) -> UIImage {
        let maxSide = max(size.width, size.height)
        guard maxSide > maxPixel else { return self }
        
        let ratio = maxPixel / maxSide
        let newSize = CGSize(
            width: size.width * ratio,
            height: size.height * ratio
        )
        
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
