import SwiftUI

struct ParentLoginView: View {
    @EnvironmentObject var settings: ParentSettings
    @State private var passwordInput = ""
    @State private var authorized = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            if authorized {
                ParentSettingsView()
            } else {
                VStack {
                    SecureField("Enter Password", text: $passwordInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Login") {
                        if settings.verifyPassword(passwordInput) {
                            authorized = true
                        } else {
                            showAlert = true
                        }
                    }
                    .alert("Incorrect Password", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    }
                    
                    Button("Reset Password") {
                        settings.resetPassword()
                    }
                    .padding(.top)
                }
                .navigationTitle("Parent Login")
            }
        }
    }
}
