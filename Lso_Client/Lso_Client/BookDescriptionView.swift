//
//  BookDescriptionView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 13/08/24.
//

import SwiftUI

struct BookDescriptionView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var cartManager: CartManager
    @State private var showAlert = false
    var availableCopies: Int
    @State private var isOutOfStock = false
    var isbn: String
    var cover: String
    @State private var webReader: String?
    @State private var description: String?
    var body: some View {
        VStack{
            ScrollView(showsIndicators: false){
                AsyncImage(url: URL(string: cover)) { image in
                    image
                        .resizable()
                        .scaledToFit()
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
                    }
                    
                }.frame(width: 300)
                    .padding()
                
                if let webReaderURL = URL(string: webReader ?? "") {
                    Link(destination: webReaderURL) {
                        HStack{
                            Text("Preview")
                                .foregroundStyle(.black)
                                .bold()
                            Image(systemName: "book.fill")
                                .foregroundStyle(.black)
                        }
                        .frame(width: 150,height:50)
                        .background(Color("SecColor"))
                    }.clipShape(.rect(cornerRadius: 10))
                } else {
                    HStack{
                        Text("Preview \nunavailable")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 150,height:50)
                    .background(.gray)
                    .clipShape(.rect(cornerRadius: 10))

                }
                
                // Add to cart button
                Button(action: {
                    Task {
                        await networkManager.requestBook(isbn: isbn)
                        
                        if networkManager.bookParsed.copies > 0 {
                            cartManager.addBook(networkManager.bookParsed)
                        } else {
                            isOutOfStock = true
                            showAlert = true
                        }
                    }
                }) {
                    HStack {
                        Text("Add to cart")
                            .foregroundStyle(.black)
                            .bold()
                        Image(systemName: "cart.fill")
                            .foregroundStyle(.black)
                    }
                    .frame(width: 150, height: 50)
                    .background(isOutOfStock ? Color.red : Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Out of Stock"),
                        message: Text("There are no copies left for this book"),
                        dismissButton: .default(Text("OK"))
                    )
                }

                Divider()
                Text("Description")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    
                Text(description ?? "Description unavailable")
                    .font(.title2)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
            }
        }
        .onAppear(){
            loadData(isbn: isbn){ book_component in
                description = book_component.first as? String
                webReader = book_component.last as? String
                if availableCopies == 0 {
                    isOutOfStock = true
                }
            }
        }
    }
}
