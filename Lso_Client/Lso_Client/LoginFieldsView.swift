//
//  LoginFieldsView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 13/08/24.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var systemImageName: String

    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .foregroundColor(Color("Color"))
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .padding()
        }
        .padding()
        .background(Color("TextFieldColor"))
        .cornerRadius(10)
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var systemImageName: String

    var body: some View {
        HStack {
            Image(systemName: systemImageName)
                .foregroundColor(Color("Color"))
            SecureField(placeholder, text: $text)
                .padding()
        }
        .padding()
        .background(Color("TextFieldColor"))
        .cornerRadius(10)
    }
}
