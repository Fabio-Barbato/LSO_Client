//
//  RegisterView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//

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
