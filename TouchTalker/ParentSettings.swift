

import Foundation
import Combine   // Required for ObservableObject

class ParentSettings: ObservableObject {
    // The parent password, stored in UserDefaults for simplicity
    @Published var password: String = UserDefaults.standard.string(forKey: "parentPassword") ?? "1234"
    
    /// Verify if the input matches the saved password
    func verifyPassword(_ input: String) -> Bool {
        return input == password
    }
    
    /// Update to a new password
    func updatePassword(_ newPassword: String) {
        password = newPassword
        UserDefaults.standard.set(newPassword, forKey: "parentPassword")
    }
    
    /// Reset password to the default value ("1234")
    func resetPassword() {
        password = "1234"
        UserDefaults.standard.set(password, forKey: "parentPassword")
    }
}
