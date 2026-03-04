import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import Combine

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
    
    init() {
        filterTrigger
//            .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
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
        
        let brightnessFilter = CIFilter.colorControls()
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

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let onChange: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(value, specifier: "%.2f")")
            Slider(value: $value, in: range)
                .onChange(of: value) {
                    onChange()
                }
        }
    }
}
