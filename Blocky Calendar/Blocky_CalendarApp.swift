//
//  Blocky_CalendarApp.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI

@main
struct Blocky_CalendarApp: App {
    
    let storageManager = StorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, storageManager.container.viewContext)
        }
    }
    
}
