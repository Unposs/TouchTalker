


import SwiftUI
import UniformTypeIdentifiers

struct ButtonDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    var buttons: [SpeechButton]
    
    init(buttons: [SpeechButton]) {
        self.buttons = buttons
    }
    
    //  Corrected initializer
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        buttons = try JSONDecoder().decode([SpeechButton].self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(buttons)
        return .init(regularFileWithContents: data)
    }
}
