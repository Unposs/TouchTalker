import Foundation
import SwiftUI

class ButtonManager: ObservableObject {
    @Published var buttons: [SpeechButton] = []
    
    init() {
        loadButtons()
    }
    
    func addButton(_ button: SpeechButton) {
        buttons.append(button)
        saveButtons()
    }
    
    func removeButton(_ button: SpeechButton) {
        buttons.removeAll { $0.id == button.id }
        saveButtons()
    }
    
    // MARK: - Persistence
    
    func saveButtons() {
        if let data = try? JSONEncoder().encode(buttons) {
            UserDefaults.standard.set(data, forKey: "buttons")
        }
    }
    
    func loadButtons() {
        if let data = UserDefaults.standard.data(forKey: "buttons"),
           let decoded = try? JSONDecoder().decode([SpeechButton].self, from: data) {
            self.buttons = decoded
        }
    }
    
    // MARK: - Export / Import
    
    func exportButtons() -> URL? {
        let filename = FileManager.default.temporaryDirectory.appendingPathComponent("TouchTalkerButtons.json")
        if let data = try? JSONEncoder().encode(buttons) {
            try? data.write(to: filename)
            return filename
        }
        return nil
    }
    
    func importButtons(from url: URL) {
        if let data = try? Data(contentsOf: url),
           let imported = try? JSONDecoder().decode([SpeechButton].self, from: data) {
            self.buttons = imported
            saveButtons()
        }
    }
}
