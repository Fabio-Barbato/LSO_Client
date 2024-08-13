//
//  LibraryView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 13/08/24.
//

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var searchText: String = ""
    @State private var selectedFilter: BookFilter = .all
    var username: String

    var body: some View {
        NavigationStack {
            VStack {
                Text("Library")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("Color"))
                // Search bar and filter picker
                HStack {
                    SearchBar(text: $searchText)
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(BookFilter.allCases, id: \.self) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }
                .padding()

                // Book list
                List(filteredBooks) { book in
                    BookRow(book: book)
                }
                .listStyle(InsetGroupedListStyle())
                //.navigationTitle("Library")
            }
            .onAppear {
                Task {
                    await networkManager.requestBookCatalog()
                }
            }
        }
    }

    // Filter books based on search text and selected filter
    var filteredBooks: [Book] {
        networkManager.bookCatalog.filter { book in
            (searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText) || book.genre.localizedCaseInsensitiveContains(searchText)) &&
            (selectedFilter == .all || (selectedFilter == .available && book.copies > 0))
        }
    }
}

// Search Bar Component
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if !text.isEmpty {
                            Button(action: {
                                text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
        }
    }
}

// Book Row Component
struct BookRow: View {
    let book: Book

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: book.cover)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                ZStack{
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 60)
                    Image(systemName:"x.circle")
                        .frame(width:37,
                               alignment: .center)
                }
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

// Enum for filtering books
enum BookFilter: String, CaseIterable {
    case all = "All"
    case available = "Available"
}


