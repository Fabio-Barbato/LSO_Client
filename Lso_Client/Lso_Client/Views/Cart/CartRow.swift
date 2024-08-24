//
//  CartRow.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import SwiftUI

struct CartRow: View {
    @EnvironmentObject var cartManager: CartManager
    var book: Book
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: book.cover)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                ProgressView()
                    .frame(width: 60, height: 90)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                Text("by \(book.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                cartManager.removeBook(book)
            }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .cornerRadius(10)
    }
}
