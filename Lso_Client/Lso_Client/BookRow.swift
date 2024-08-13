//
//  BookRow.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 13/08/24.
//

import SwiftUI

// Book Row Component
struct BookRow: View {
    let book: Book

    var body: some View {
        NavigationLink(destination: BookDescriptionView(availableCopies: book.copies, isbn: book.ISBN,cover: book.cover)){
            HStack(alignment: .top) {
                AsyncImage(url: URL(string: book.cover)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 90)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 90)
                }
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.title)
                        .font(.headline)
                    Text(book.author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Genre: \(book.genre)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Available Copies: \(book.copies)")
                        .font(.subheadline)
                        .foregroundColor(book.copies > 0 ? .green : .red)
                }
                .padding(.leading, 10)
            }
        }
    }
}
