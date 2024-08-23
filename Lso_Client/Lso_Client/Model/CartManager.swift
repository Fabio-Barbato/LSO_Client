//
//  CartManager.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 23/08/24.
//

import Foundation

class CartManager: ObservableObject {
    @Published var cart: [Book] = []
    
    func addBook(_ book: Book) {
        cart.append(book)
    }
    
    func removeBook(_ book: Book) {
        if let index = cart.firstIndex(where: { $0.ISBN == book.ISBN }) {
            cart.remove(at: index)
        }
    }
}
