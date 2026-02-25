//
//  Photo_EditerApp.swift
//  Photo Editer
//
//  Created by Nguyễn Công Thư on 25/2/26.
//

import SwiftUI
import CoreData

@main
struct Photo_EditerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
