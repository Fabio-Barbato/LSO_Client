//
//  ContentView.swift
//  LSO_Client
//
//  Created by Fabio Barbato on 08/08/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            client.connectToServer()
        }
    }
}

#Preview {
    ContentView()
}
