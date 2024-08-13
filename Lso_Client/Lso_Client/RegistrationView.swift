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
    @State private var registrationStatusTitle: String = "Registration Failed"
    @State private var showAlert = false


    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                // Logo and Title
                VStack(spacing: 10) {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("Color"))

                    Text("Register")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("Color"))
                }
                .padding(.top, 40)

                // Name and Surname Fields
                VStack(spacing: 20) {
                    CustomTextField(
                        placeholder: "Enter your name",
                        text: $name,
                        systemImageName: "person.fill"
                    )

                    CustomTextField(
                        placeholder: "Enter your surname",
                        text: $surname,
                        systemImageName: "person.fill"
                    )

                    CustomTextField(
                        placeholder: "Enter your username",
                        text: $username,
                        systemImageName: "person.crop.circle.fill"
                    )

                    CustomSecureField(
                        placeholder: "Enter your password",
                        text: $password,
                        systemImageName: "lock.fill"
                    )
                }
                .padding(.horizontal, 20)

                // Register Button
                Button(action: {
                    Task {
                        await register()
                    }
                }) {
                    Text("Register")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Color"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(registrationStatusTitle),
                        message: Text(registrationStatus),
                        dismissButton: .default(Text("OK"))
                    )
                }

                
                Spacer()
            }
            .padding(.vertical)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .scrollDismissesKeyboard(.interactively)
    }


    func register() async {
        guard !name.isEmpty, !surname.isEmpty, !username.isEmpty, !password.isEmpty else {
            registrationStatus = "Please fill in all fields"
            showAlert = true
            return
        }

        let response = await networkManager.register(name: name, surname: surname, username: username, password: password)
        DispatchQueue.main.async {
            registrationStatus = response
            if registrationStatus == "Username already exists"{
                showAlert = true
            }else{
                showAlert = true
                registrationStatusTitle = "Registration completed!"
                registrationStatus = "Your account has been successfully registered"
            }
        }
    }
}
