//
//  StorageManager.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import Foundation
import CoreData
import SwiftUI

class StorageManager {
    
    static let shared = StorageManager()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Blocky_Calendar")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
}
