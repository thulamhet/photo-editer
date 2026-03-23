//
//  EditablePhoto.swift
//  Photo Editer
//
//  Created by admin on 3/23/26.
//

import SwiftUI

struct EditablePhoto: Hashable {
    let id = UUID()
    let title: String
    let imageData: Data
    
    var image: UIImage {
        UIImage(data: imageData) ?? UIImage()
    }
}
