//
//  ParentSettingsView.swift
//  TouchTalker
//
//  Created by Yong Wang on 10/11/25.
//


import SwiftUI

struct ParentSettingsView: View {
    @EnvironmentObject var buttonManager: ButtonManager
    @EnvironmentObject var settings: ParentSettings
    @State private var showImporter = false
    @State private var showExporter = false
    @State private var newText = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            List {
                ForEach(buttonManager.buttons) { button in
                    HStack {
                        if let imageData = button.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .cornerRadius(6)
                        }
                        Text(button.text)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { buttonManager.buttons.remove(at: $0) }
                    buttonManager.saveButtons()
                }
            }
            
            VStack {
                TextField("Button Text", text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Choose Image") {
                    showImagePicker = true
                }
                Button("Add Button") {
                    if !newText.isEmpty {
                        let newButton = SpeechButton(
                            text: newText,
                            imageData: image?.jpegData(compressionQuality: 0.8)
                        )
                        buttonManager.addButton(newButton)
                        newText = ""
                        image = nil
                    }
                }
                .padding(.top)
            }
            .padding()
            
            HStack {
                Button("Export Buttons") {
                    showExporter = true
                }
                .padding()
                .fileExporter(
                    isPresented: $showExporter,
                    document: ButtonDocument(buttons: buttonManager.buttons),
                    contentType: .json,
                    defaultFilename: "TouchTalkerButtons"
                ) { _ in }
                
                Button("Import Buttons") {
                    showImporter = true
                }
                .padding()
                .fileImporter(
                    isPresented: $showImporter,
                    allowedContentTypes: [.json]
                ) { result in
                    if case .success(let url) = result {
                        buttonManager.importButtons(from: url)
                    }
                }
            }
        }
        .navigationTitle("Parent Settings")
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}
