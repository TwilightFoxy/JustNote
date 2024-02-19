//
//  JustNoteApp.swift
//  JustNote
//
//  Created by Левон Михаелян on 19.02.2024.
//

import SwiftUI

@main
struct JustNoteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
