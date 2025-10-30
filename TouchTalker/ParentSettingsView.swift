import SwiftUI
import UniformTypeIdentifiers

struct ParentSettingsView: View {
    @EnvironmentObject var buttonManager: ButtonManager
    @EnvironmentObject var settings: ParentSettings
    @Environment(\.dismiss) private var dismiss

    @State private var showImporter = false
    @State private var showExporter = false
    @State private var newText = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var isAnalyzing = false    //  New state for progress indicator
    
    var body: some View {
        VStack {
            if isAnalyzing {
                //  Loading indicator
                VStack(spacing: 10) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Analyzing image…")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            
            List {
                ForEach(buttonManager.buttons) { button in
                    VStack(alignment: .leading) {
                        HStack {
                            if let data = button.imageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(6)
                            }
                            Text(button.text)
                            Spacer()
                        }
                        
                        HStack {
                            Button("Modify") {
                                newText = button.text
                                image = button.imageData.flatMap { UIImage(data: $0) }
                                
                                buttonManager.removeButton(button)
                            }
                            .foregroundColor(.blue)
                            
                            Button("Delete") {
                                buttonManager.removeButton(button)
                            }
                            .foregroundColor(.red)
                        }
                        .padding(.leading, 60)
                    }
                }
            }


            VStack {
                TextField("Button Text", text: $newText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Choose Image") {
                    showImagePicker = true
                }

                Button("Add Button") {
                    guard !newText.isEmpty else { return }
                    let newButton = SpeechButton(
                        text: newText,
                        imageData: image?.jpegData(compressionQuality: 0.8)
                    )
                    buttonManager.addButton(newButton)
                    newText = ""
                    image = nil
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Exit") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
        //  Trigger OCR + AI label detection with progress feedback
        .onChange(of: image) { newImage in
            guard let selected = newImage else { return }
            isAnalyzing = true
            newText = ""  // clear previous text while analyzing
            
            ImageTextRecognizer.shared.recognizeContent(in: selected) { recognized in
                DispatchQueue.main.async {
                    isAnalyzing = false
                    if let text = recognized, !text.isEmpty {
                        newText = text
                    } else {
                        newText = "Unknown Object"
                    }
                }
            }
        }
    }
}

