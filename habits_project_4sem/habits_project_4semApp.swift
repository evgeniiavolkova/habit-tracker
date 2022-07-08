//
//  habits_project_4semApp.swift
//  habits_project_4sem
//
//  Created by Евгения Волкова on 31.05.2022.
//

import SwiftUI

 @main
struct habits_project_4semApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
