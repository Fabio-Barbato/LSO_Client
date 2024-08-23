//
//  TabScreen.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 14/08/24.
//

import SwiftUI

struct TabScreen: View {
    var username: String

    var body: some View {
        TabView{
            LibraryView()
                .tabItem {
                    Label("Library",systemImage: "books.vertical.fill")
                }
            
            CartView(username: username)
                .tabItem {
                    Label("Checkout",systemImage: "cart.fill")
                }
            
            NotificationsView(username: username)
                .tabItem {
                    Label("Notifications",systemImage: "bell.fill")
                }
        }.accentColor(Color("Color"))
    }
}
