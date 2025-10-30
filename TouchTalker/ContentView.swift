import SwiftUI

struct ContentView: View {
    @EnvironmentObject var buttonManager: ButtonManager
    @EnvironmentObject var settings: ParentSettings
    @State private var showParentLogin = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {

                    // Existing speech buttons
                    ForEach($buttonManager.buttons, id: \.id) { $button in
                        Button {
                            SpeechManager.shared.speak(text: button.text)
                        } label: {
                            VStack {
                                if let imageData = button.imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 120)
                                }
                                Text(button.text)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(16)
                            .shadow(radius: 3)
                        }
                    }

                    //  New PictureBuddy button
                    NavigationLink(destination: PictureBuddyView()) {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .foregroundColor(.blue)

                            Text("PictureBuddy")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.tertiarySystemBackground))
                        .cornerRadius(16)
                        .shadow(radius: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 60)
            }
            .frame(maxHeight: .infinity)
            .navigationTitle("TouchTalker")
            .toolbar {
                Button("Parent") {
                    showParentLogin = true
                }
            }
            .sheet(isPresented: $showParentLogin) {
                ParentLoginView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
