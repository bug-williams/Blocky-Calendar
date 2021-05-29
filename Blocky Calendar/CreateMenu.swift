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
    @State var selectedColor: Int = 0
    
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
                })
            }
            .padding(.bottom)
            VStack(alignment: .leading) {
                Text("NAME")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                CustomTextField(textFieldValue: $textFieldValue, label: nil, placeholder: "Event name")
            }
            VStack(alignment: .leading) {
                Text("COLOR")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 0, color: .pink)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 1, color: .orange)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 2, color: .yellow)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 3, color: .green)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 4, color: .blue)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 5, color: .purple)
                        ColorButton(currentlySelectedColor: $selectedColor, colorNumber: 6, color: .gray)
                    }
                    .padding(.horizontal, 32)
                }
                .padding(.horizontal, -32)
            }
            Button(action: {
                if selectedEventBlock != nil {
                    dataHandlerDelegate.addEvent(title: textFieldValue, block: selectedEventBlock!, color: selectedColor)
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
            .padding(.top)
        }
        .padding(24)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.15), radius: 16, y: 16)
        .shadow(color: Color.black.opacity(0.1), radius: 4, y: 4)
    }
    
}

struct ColorButton: View {
    
    @Binding var currentlySelectedColor: Int
    var colorNumber: Int
    var color: Color
    
    var body: some View {
        Button(action: {
            currentlySelectedColor = colorNumber
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(colorNumber == currentlySelectedColor ? 1 : 0)
            }
        })
    }
    
}
