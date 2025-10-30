//
//  Models.swift
//  TouchTalker
//
//  Created by Yong Wang on 10/11/25.
//

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
