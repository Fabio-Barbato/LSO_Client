//
//  LoginView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginStatus: String = ""
    @State private var navigateToCatalog = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Logo and Title
                VStack(spacing: 10) {
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("Color"))

                    Text("BitBooks")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("Color"))
                }
                .padding(.top, 40)

                // Username and Password Fields
                VStack(spacing: 20) {
                    CustomTextField(
                        placeholder: "Enter your username",
                        text: $username,
                        systemImageName: "person.fill"
                    )

                    CustomSecureField(
                        placeholder: "Enter your password",
                        text: $password,
                        systemImageName: "lock.fill"
                    )
                }
                .padding(.horizontal, 20)

                // Login and Register Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Login")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Color"))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: RegistrationView()) {
                        Text("Register")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(Color("TextColor"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)

                // Login Status Message
                if !loginStatus.isEmpty {
                    Text(loginStatus)
                        .padding()
                        .foregroundColor(loginStatus.contains("failed") ? .red : .green)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .animation(.easeInOut, value: loginStatus)
                }
                
                Spacer()
            }
            .onAppear {
                #if DEBUG
                UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                #endif
            }
            .navigationDestination(isPresented: $navigateToCatalog) {
                LibraryView(username: username)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    func login() async {
        let response = await networkManager.login(username: username, password: password)
        DispatchQueue.main.async {
            if response == "Successfully logged" {
                loginStatus = "Login successful. Loading catalog..."
                Task {
                    await networkManager.requestBookCatalog()
                    navigateToCatalog = true
                }
            } else {
                loginStatus = "Login failed. Please try again."
            }
        }
    }
}

#Preview {
    LoginView()
}
