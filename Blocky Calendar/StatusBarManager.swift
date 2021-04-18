//
//  StatusBarManager.swift
//  Blocky Calendar
//
//  Created by Bug on 4/7/21.
//

import SwiftUI

class StatusBarManager {
    
    static let shared = StatusBarManager()
    
    func getStatusBarHeight() -> CGFloat {
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        return statusBarHeight
        
    }
    
}
