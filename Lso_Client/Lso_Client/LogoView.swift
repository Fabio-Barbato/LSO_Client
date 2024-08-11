//
//  LogoView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        // App Icon
        VStack {
            Image(systemName: "books.vertical.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(Color("Color"))
            
            
            Text("BitBooks")
                .font(.largeTitle)
                .foregroundColor(Color("Color"))
                .bold()
        }
    }
}

#Preview {
    LogoView()
}
