//
//  CatalogView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 12/08/24.
//

import SwiftUI

struct CatalogView: View {
    @EnvironmentObject var networkManager: NetworkManager

    var body: some View {
        NavigationStack {
            List(networkManager.bookCatalog) { book in
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text("Author: \(book.author)")
                        .font(.subheadline)
                    Text("ISBN: \(book.ISBN)")
                        .font(.subheadline)
                    Text("Genre: \(book.genre)")
                        .font(.subheadline)
                    Text("Available Copies: \(book.copies)")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Book Catalog")
            .onAppear {
                Task {
                    await networkManager.requestBookCatalog()
                }
            }
        }
    }
}

#Preview {
    CatalogView()
        .environmentObject(NetworkManager.shared)
}
