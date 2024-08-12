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
                VStack {
                    // Logo and Title
                    Image(systemName: "books.vertical.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color("Color"))
                    
                    Text("BitBooks")
                        .font(.largeTitle)
                        .foregroundColor(Color("Color"))
                        .bold()
                    
                    // Username Field
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("Color"))
                            TextField("Enter your username", text: $username)
                        }
                        .padding()
                        .background(LoginField())
                    
                    // Password Field
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color("Color"))
                            SecureField("Enter your password", text: $password)
                        }
                        .padding()
                        .background(LoginField())

                    
                    // Login and Register Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            Task {
                                await login()
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                                .padding()
                                .background(Color("Color"))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: RegistrationView()) {
                            Text("Register")
                                .foregroundColor(.black)
                                .font(.title2)
                                .bold()
                                .padding()
                                .background(Color("Color"))
                                .cornerRadius(10)
                        }
                    }
                    
                    // Login Status Message
                    Text(loginStatus)
                        //.padding()
                        .multilineTextAlignment(.center)
                }
                .onAppear {
                    #if DEBUG
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                    #endif
                }
            .navigationDestination(isPresented: $navigateToCatalog) {
                CatalogView()
            }
        }
    }

/*    func login() async {
        guard !username.isEmpty, !password.isEmpty else {
            loginStatus = "Please fill in all fields."
            return
        }

        let response = await networkManager.login(username: username, password: password)
        DispatchQueue.main.async {
            loginStatus = response
            if response == "Successfully logged" {
                navigateToCatalog = true
            }
        }
    }*/
     func login() async {
        let response = await networkManager.login(username: username, password: password)
        if response == "Successfully logged" {
            loginStatus = "Login successful. Loading catalog..."
            await networkManager.requestBookCatalog()
            navigateToCatalog = true
        } else {
            loginStatus = "Login failed. Please try again."
        }
    }
}

#Preview {
    LoginView()
}
