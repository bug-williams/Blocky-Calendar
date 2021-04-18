//
//  CustomTextField.swift
//  Blocky Calendar
//
//  Created by Bug on 4/6/21.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var textFieldValue: String
    
    let label: String?
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            if label != nil {
                Text(label!)
                    .font(.system(.caption, design: .default))
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
            }
            TextField(placeholder, text: $textFieldValue)
                .font(.system(.body, design: .rounded))
                .padding(16)
                .background(Color(UIColor.tertiarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(textFieldValue: .constant(""), label: "Text Field", placeholder: "Placeholder")
    }
}
