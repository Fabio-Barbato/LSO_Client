//
//  CheckoutView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 14/08/24.
//

import SwiftUI

// Classe per gestire il carrello, conforme a ObservableObject
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

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Titolo
                Text("Your Cart")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("Color"))
                    .padding(.top, 40)

                // Lista di libri
                if cartManager.cart.isEmpty {
                    Text("Your cart is empty")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(cartManager.cart) { book in
                                HStack {
                                    AsyncImage(url: URL(string: book.cover)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 70, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        Rectangle()
                                            .fill(.gray)
                                            .frame(width: 70, height: 100)
                                            .overlay(
                                                Text("No Cover")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                            )
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
                                .background(Color("SecColor").opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Bottone di Checkout
                Button(action: {
                    checkout()
                }) {
                    Text("Proceed to Checkout")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Color"))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .opacity(cartManager.cart.isEmpty ? 0.5 : 1)
                .disabled(cartManager.cart.isEmpty)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Checkout"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    func checkout() {
        guard !cartManager.cart.isEmpty else { return }
        // Logica di checkout
        alertMessage = "Your books have been successfully borrowed."
        cartManager.cart.removeAll() // Svuota il carrello dopo il prestito
        showAlert = true
    }
}
