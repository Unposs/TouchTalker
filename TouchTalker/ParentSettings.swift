import Foundation

class ParentSettings: ObservableObject {
    @Published var password: String = UserDefaults.standard.string(forKey: "parentPassword") ?? "1234"
    
    func verifyPassword(_ input: String) -> Bool {
        return input == password
    }
    
    func updatePassword(_ newPassword: String) {
        password = newPassword
        UserDefaults.standard.set(newPassword, forKey: "parentPassword")
    }
    
    func resetPassword() {
        password = "1234"
        UserDefaults.standard.set(password, forKey: "parentPassword")
    }
}
