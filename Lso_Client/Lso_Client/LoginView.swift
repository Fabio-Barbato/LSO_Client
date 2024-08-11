import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginStatus: String = ""
    
    var body: some View {
        VStack(spacing: 60) {
            LogoView()
            
            // Username Field
            HStack(spacing: 5) {
                Image(systemName: "person.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("Color"))
                    .padding()
                TextField("Enter your username", text: $username)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Color"), lineWidth: 2)
            }
            
            // Password Field
            HStack(spacing: 5) {
                Image(systemName: "lock.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("Color"))
                    .padding()
                SecureField("Enter your password", text: $password)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Color"), lineWidth: 2)
            }
            
            // Login Button
            HStack {
                Button(action: {
                    login(username: username, password: password)
                }) {
                    Text("Login")
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Color"))
                        .cornerRadius(10)
                }
                Button(action: {
                    // login()
                }) {
                    Text("Register")
                        .foregroundColor(.black)
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Color"))
                        .cornerRadius(10)
                }
            }
            
            // Login Status Message
            Text(loginStatus)
                .foregroundColor(.white)
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding()
        .task {
            await connectToServerAsync()
        }
    }
    func connectToServerAsync() async {
        await withCheckedContinuation { continuation in
            connectToServer()
            continuation.resume()
        }
    }
}

#Preview {
    LoginView()
}
