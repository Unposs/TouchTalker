
import SwiftUI
import AVFoundation
import Vision
import CoreML

struct PictureBuddyView: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var prediction: String = ""
    @State private var isAnalyzing = false

    var body: some View {
        VStack(spacing: 20) {
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }

            if isAnalyzing {
                ProgressView("Analyzing image...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if !prediction.isEmpty {
                VStack(spacing: 10) {
                    Text("AI thinks this is:")
                        .font(.headline)
                        .foregroundColor(.gray)

                    Text(prediction)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // 🔊 Play button using your SpeechManager
                    Button(action: {
                        SpeechManager.shared.speak(text: prediction)
                    }) {
                        Label("Play", systemImage: "speaker.wave.2.fill")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }

            Button("Select Image") {
                showImagePicker = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("PictureBuddy")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        //  Auto analyze when image changes
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                analyzeImage(image)
            }
        }
    }

    // MARK: - Analyze Image with CoreML
    private func analyzeImage(_ image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }
        isAnalyzing = true
        prediction = ""

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let model = try VNCoreMLModel(for: MobileNetV2().model)
                let request = VNCoreMLRequest(model: model) { request, _ in
                    if let result = request.results?.first as? VNClassificationObservation {
                        DispatchQueue.main.async {
                            self.prediction = result.identifier
                            self.isAnalyzing = false

                            //  Automatically speak after analysis
                            SpeechManager.shared.speak(text: result.identifier)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.prediction = "I’m not sure what this is."
                            self.isAnalyzing = false
                        }
                    }
                }

                let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
                try handler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    self.prediction = "Analysis failed."
                    self.isAnalyzing = false
                }
            }
        }
    }
}
