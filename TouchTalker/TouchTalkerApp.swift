

import SwiftUI

@main
struct TouchTalkerApp: App {
    @StateObject private var buttonManager = ButtonManager()
    @StateObject private var settings = ParentSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(buttonManager)
                .environmentObject(settings)
        }
    }
}
