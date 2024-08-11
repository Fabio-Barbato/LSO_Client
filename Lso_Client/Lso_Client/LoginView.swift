import SwiftUI

struct LoginView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginStatus: String = ""

    var body: some View {
        NavigationStack{
            ScrollView(showsIndicators: false){
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
                        .padding(.bottom, 20)
                    
                    // Username Field
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("Color"))
                            TextField("Enter your username", text: $username)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
                    }
                    .padding(.bottom, 20)
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color("Color"))
                            SecureField("Enter your password", text: $password)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color("Color"), lineWidth: 2))
                    }
                    .padding(.bottom, 20)
                    
                    // Login and Register Buttons
                    HStack(spacing: 20) {
                        Button(action: {
                            login(username: username, password: password)
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
                        .padding()
                        .multilineTextAlignment(.center)
                }                .onAppear {
#if DEBUG
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
#endif
                }
                .padding()
            }.scrollDismissesKeyboard(.interactively)
    }
    }
    func login(username: String, password: String) {
        guard !username.isEmpty, !password.isEmpty else {
            loginStatus = "Please fill in all fields."
            return
        }

        let message = "LOGIN \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            networkManager.send(data: messageData)
        }
    }
}

#Preview {
    LoginView()
}
