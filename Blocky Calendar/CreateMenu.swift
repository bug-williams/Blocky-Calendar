//
//  CreateMenu.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI
import CoreData

struct CreateMenu: View {
    
    let storageManager = StorageManager.shared
    
    var dataHandlerDelegate: DataHanderDelegate
    
    @Binding var createMenuIsVisible: Bool
    @Binding var selectedEventBlock: Int?
    
    @State var textFieldValue: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 28, height: 28)
                Spacer()
                Text("New Event")
                    .font(.system(.title, design: .rounded))
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    UIApplication.shared.endEditing()
                    withAnimation(.spring()) {
                        createMenuIsVisible = false
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                })
            }
            .padding(.bottom)
            CustomTextField(textFieldValue: $textFieldValue, label: nil, placeholder: "Event name")
            Button(action: {
                if selectedEventBlock != nil {
                    dataHandlerDelegate.addEvent(title: textFieldValue, block: selectedEventBlock!)
                    textFieldValue = ""
                    UIApplication.shared.endEditing()
                }
                withAnimation(.spring()) {
                    createMenuIsVisible = false
                }
            }, label: {
                Text("Create")
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            })
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 16, y: 16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, y: 4)
    }
    
}
