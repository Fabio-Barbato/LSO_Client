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
            (searchText.isEmpty || book.title.localizedCaseInsensitiveContains(searchText)) &&
            (selectedFilter == .all || (selectedFilter == .available && book.copies > 0))
        }
    }
}

// Enum for filtering books
enum BookFilter: String, CaseIterable {
    case all = "All"
    case available = "Available"
}
