//
//  SettingsPage.swift
//  Blocky Calendar
//
//  Created by Bug on 5/27/21.
//

import SwiftUI

struct SettingsPage: View {
    
    @Binding var showSettingsPage: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                HStack {
                    Spacer()
                    Text("Settings")
                        .font(.system(.headline, design: .rounded))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        showSettingsPage.toggle()
                    }, label: {
                        Text("Done")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                    })
                }
            }
            Spacer()
        }
        .padding()
    }
    
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage(showSettingsPage: .constant(true))
    }
}
