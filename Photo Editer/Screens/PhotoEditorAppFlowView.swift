//
//  PhotoEditorAppFlowView.swift
//  Photo Editer
//
//  Created by admin on 3/23/26.
//

import SwiftUI

enum Route: Hashable {
    case importPhotos
    case realEditor(EditablePhoto)
}

struct PhotoEditorAppFlowView: View {
    @Namespace private var namespace
    @State private var path: [Route] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            DashboardScreen(namespace: namespace) { route in
                path.append(route)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .importPhotos:
                        ImportScreen(namespace: namespace) { selected in
                          
                        } onImportedPhoto: { photo in
                            path.append(.realEditor(photo))
                        }
                case .realEditor(let photo):
                    RealPhotoEditorScreen(photo: photo)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

