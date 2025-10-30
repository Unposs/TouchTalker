import SwiftUI

struct ParentLoginView: View {
    @EnvironmentObject var settings: ParentSettings
    @State private var passwordInput = ""
    @State private var parentKeyInput = ""
    @State private var newPassword = ""
    @State private var authorized = false
    @State private var showAlert = false
    @State private var showResetDialog = false
    @State private var showSuccess = false

    // Parent verification key
    let parentKey = "parent2025"

    var body: some View {
        NavigationView {
            if authorized {
                ParentSettingsView()
            } else {
                VStack(spacing: 20) {
                    SecureField("Enter password", text: $passwordInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Login") {
                        if settings.verifyPassword(passwordInput) {
                            authorized = true
                        } else {
                            showAlert = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)

                    Button("Reset Password") {
                        showResetDialog = true
                    }
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                }
                .navigationTitle("Parent Login")

                // Incorrect password alert
                .alert("Incorrect Password", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Please enter the correct password or parent key.")
                }

                // Reset password dialog (actually change password)
                .alert("Reset Password", isPresented: $showResetDialog) {
                    SecureField("Enter Parent Key", text: $parentKeyInput)
                    SecureField("Enter New Password", text: $newPassword)
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm") {
                        if parentKeyInput == parentKey {
                            settings.updatePassword(newPassword)
                            showSuccess = true
                        } else {
                            showAlert = true
                        }
                    }
                } message: {
                    Text("Enter the parent key and your new password.")
                }

                // Success message
                .alert("Password Changed", isPresented: $showSuccess) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Your password has been updated successfully.")
                }
            }
        }
    }
}
