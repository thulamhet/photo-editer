import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject private var viewModel = PhotoEditorViewModel()
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                if let image = viewModel.displayImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 420)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.15))
                        .overlay {
                            Text("No Image")
                                .foregroundStyle(.secondary)
                        }
                        .frame(height: 320)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Brightness: \(viewModel.brightness, specifier: "%.2f")")
                
                Slider(
                    value: Binding(
                        get: { viewModel.brightness },
                        set: { newValue in
                            viewModel.sliderChanged(to: newValue)
                        }
                    ),
                    in: -1.0...1.0,
                    onEditingChanged: { isEditing in
                        viewModel.sliderEditingChanged(isEditing: isEditing)
                    }
                )
            }
            .padding(.horizontal)
            
            HStack(spacing: 12) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Chọn ảnh")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Reset") {
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onChange(of: selectedItem) { _, newItem in
            Task {
                guard let newItem else { return }
                
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.setImage(image)
                }
            }
        }
    }
}
