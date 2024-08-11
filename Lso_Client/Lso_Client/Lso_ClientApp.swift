import SwiftUI

@main
struct Lso_ClientApp: App {
    @StateObject private var networkManager = NetworkManager.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(networkManager)
        }
    }
}
