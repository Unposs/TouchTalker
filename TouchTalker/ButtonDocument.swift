import SwiftUI
import UniformTypeIdentifiers

struct ButtonDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var buttons: [SpeechButton]
    
    init(buttons: [SpeechButton]) {
        self.buttons = buttons
    }
    
    init(configuration: ReadConfiguration) throws {
        let data = try Data(contentsOf: configuration.file)
        buttons = try JSONDecoder().decode([SpeechButton].self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(buttons)
        return .init(regularFileWithContents: data)
    }
}
