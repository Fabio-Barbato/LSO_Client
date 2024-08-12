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
            if networkManager.bookCatalog.isEmpty {
                ProgressView("Loading books...")
                    .navigationTitle("Book Catalog")
            } else {
                List(networkManager.bookCatalog) { book in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(book.title)
                                .font(.title)
                            Text("Author: \(book.author)")
                                .font(.title3)
                            Text("ISBN: \(book.ISBN)")
                                .font(.title3)
                            Text("Genre: \(book.genre)")
                                .font(.title3)
                            Text("Available Copies: \(book.copies)")
                                .font(.title3)
                        }
                        AsyncImage(url: URL(string: book.cover)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 250)
                                .clipShape(.rect(cornerRadius: 8))
                        }placeholder: {
                            ZStack{
                                Rectangle()
                                    .fill(.gray)
                                    .frame(width: 160)
                                Text("Cover \nunavailable")
                                    .frame(width:100,
                                           alignment: .center)
                                    .font(.title3)
                            }}
                    }

                }
                .navigationTitle("Book Catalog")
            }
        }.onAppear {
            Task {
                await networkManager.requestBookCatalog()
            }
        }
    }
}

#Preview {
    CatalogView()
        .environmentObject(NetworkManager.shared)
}
