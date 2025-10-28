import UIKit
import Vision

class ImageTextRecognizer {
    static let shared = ImageTextRecognizer()
    
    func recognizeText(in image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let results = request.results as? [VNRecognizedTextObservation] {
                let recognizedStrings = results.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                completion(recognizedStrings.joined(separator: " "))
            } else {
                completion(nil)
            }
        }
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Text recognition error: \(error)")
                completion(nil)
            }
        }
    }
}
