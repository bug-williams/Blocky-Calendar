//
//  DataHandlerProtocol.swift
//  Blocky Calendar
//
//  Created by Bug on 4/9/21.
//

import Foundation
import SwiftUI
import CoreData

protocol DataHanderDelegate {
    
    func addEvent(title: String, block: Int, color: Int)
    func deleteEvent(offsets: IndexSet)
    func getEventIndexFromBlock(block: Int) -> Int
    
}
