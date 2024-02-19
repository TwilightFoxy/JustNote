//
//  JustNoteApp.swift
//  JustNote
//
//  Created by Левон Михаелян on 19.02.2024.
//

import SwiftUI
import CoreData

@main
struct JustNoteApp: App {
    
    let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "JustNote") // Имя модели данных
            container.loadPersistentStores { storeDescription, error in
                if let error = error as NSError? {
                    fatalError("Нерешенная ошибка: \(error), \(error.userInfo)")
                }
            }
            return container
        }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
