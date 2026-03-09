import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine

struct ContentView: View {
    
    @StateObject private var viewModel = EditorViewModel()
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            if let image = viewModel.outputImage ?? viewModel.inputImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .cornerRadius(12)
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("Select Photo"))
            }
            
            PhotosPicker("Pick Image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) { _, _ in
                    loadImage()
                }
                .padding()
            
            Group {
                SliderView(title: "Brightness",
                           value: $viewModel.brightness,
                           range: -1...1) {
                    viewModel.scheduleApplyFilters()
                }
                
                SliderView(title: "Contrast",
                           value: $viewModel.contrast,
                           range: 0...4) {
                    viewModel.scheduleApplyFilters()
                }
                
                SliderView(title: "Saturation",
                           value: $viewModel.saturation,
                           range: 0...4) {
                    viewModel.scheduleApplyFilters()
                }
            }
            .padding(.horizontal)
            
            Button("Reset") {
                viewModel.reset()
            }
            .padding()
        }
    }
}

extension ContentView {
    private func loadImage() {
        Task {
            guard let data = try? await selectedItem?.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else { return }
            
            viewModel.inputImage = uiImage
            viewModel.outputImage = uiImage
            viewModel.applyFilters()
        }
    }
}

