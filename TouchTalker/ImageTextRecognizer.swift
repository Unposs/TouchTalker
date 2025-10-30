import UIKit
import Vision
import CoreML

class ImageTextRecognizer {
    static let shared = ImageTextRecognizer()
    
    func recognizeContent(in image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        // Step 1: OCR first
        let textRequest = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedText = results
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: " ")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                if !recognizedText.isEmpty {
                    completion(recognizedText)
                    return
                }
            }
            // Step 2: No text found — use MobileNetV2
            self.classifyWithMobileNet(in: cgImage, completion: completion)
        }
        
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([textRequest])
            } catch {
                print("OCR error: \(error)")
                self.classifyWithMobileNet(in: cgImage, completion: completion)
            }
        }
    }

    // MARK: - Classification with MobileNetV2
    private func classifyWithMobileNet(in cgImage: CGImage, completion: @escaping (String?) -> Void) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else {
            completion(nil)
            return
        }

        let request = VNCoreMLRequest(model: model) { request, error in
            if let results = request.results as? [VNClassificationObservation],
               let topResult = results.first {
                let name = topResult.identifier
                    .replacingOccurrences(of: ",", with: "")
                    .capitalized
                completion(name)
            } else {
                completion(nil)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try VNImageRequestHandler(cgImage: cgImage, options: [:]).perform([request])
            } catch {
                print("MobileNetV2 error: \(error)")
                completion(nil)
            }
        }
    }
}

