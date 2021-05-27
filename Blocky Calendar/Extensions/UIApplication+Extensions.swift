//
//  UIApplication+Extensions.swift
//  Blocky Calendar
//
//  Created by Bug on 4/7/21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
