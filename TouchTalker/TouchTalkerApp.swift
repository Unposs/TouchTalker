//
//  TouchTalkerApp.swift
//  TouchTalker
//
//  Created by Yong Wang on 10/11/25.
//

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
