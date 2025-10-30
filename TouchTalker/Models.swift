
import SwiftUI

struct SpeechButton: Identifiable, Codable {
    let id: UUID
    var text: String
    var imageData: Data?
    
    init(id: UUID = UUID(), text: String, imageData: Data? = nil) {
        self.id = id
        self.text = text
        self.imageData = imageData
    }
}
