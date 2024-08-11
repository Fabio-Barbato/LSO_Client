//
//  RegisterView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var registrationStatus: String = ""
    
    var body: some View {
        ScrollView(showsIndicators:false){
        VStack(spacing: 20) {
            // Logo or app icon
            Image(systemName: "books.vertical.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color("Color"))
                .padding(.top, 50)
            
            Text("Register")
                .font(.largeTitle)
                .foregroundColor(Color("Color"))
                .bold()
                .padding(.bottom, 20)
            
            // Name Field
            HStack {
                TextField("Enter your name", text: $name)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
            }
            .padding(.horizontal)
            
            // Surname Field
            HStack {
                TextField("Enter your surname", text: $surname)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
            }
            .padding(.horizontal)
            
            // Username Field
            HStack {
                TextField("Enter your username", text: $username)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
            }
            .padding(.horizontal)
            
            // Password Field
            HStack {
                TextField("Enter your password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
            }
            .padding(.horizontal)
            
            
            // Register Button
            HStack {
                Button(action: {
                    register(name: name, surname: surname, username: username, password: password)
                }) {
                    Text("Register")
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                        .padding()
                        .background(Color("Color"))
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            
            // Registration Status Message
            Text(registrationStatus)
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
        }
            .padding()}.scrollDismissesKeyboard(.interactively)
    }
    
    func register(name: String, surname: String, username: String, password: String) {
        guard !name.isEmpty, !surname.isEmpty, !username.isEmpty, !password.isEmpty else {
            registrationStatus = "Please fill in all fields and make sure passwords match."
            return
        }
        
        let message = "ADD_USER \(name) \(surname) \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            networkManager.send(data: messageData)
        }
    }
}

#Preview {
    RegistrationView()
}
