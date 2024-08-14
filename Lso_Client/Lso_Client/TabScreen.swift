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
            LibraryView(username: username)
                .tabItem {
                    Label("Library",systemImage: "books.vertical.fill")
                        .foregroundStyle(Color("Color"))
                }
            
            CartView()
                .tabItem {
                    Label("Checkout",systemImage: "cart.fill")
                        .foregroundStyle(Color("Color"))

                }
        }
    }
}
