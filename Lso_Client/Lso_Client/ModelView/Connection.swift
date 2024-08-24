//
//  Connection.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    @Published var bookCatalog: [Book] = []
    @Published var notifications: [Notification] = []
    var bookParsed = Book(title: "", ISBN: "", author: "", genre: "", copies: 0, given_copies: 0, cover: "")
    private let host = NWEndpoint.Host("192.168.1.116")
    private let port = NWEndpoint.Port(rawValue: 8080)!
    private var connection: NWConnection?

    private init() {
        connectToServer()
    }

    private func connectToServer() {
        connection = NWConnection(host: host, port: port, using: .tcp)
        connection?.start(queue: .global())
    }

    func send(data: Data) {
        connection?.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Error sending data: \(error.localizedDescription)")
            } else {
                print("Data sent")
            }
        })
    }

    func receive() async -> String {
        return await withCheckedContinuation { continuation in
            connection?.receive(minimumIncompleteLength: 1, maximumLength: 4096) { data, _, isComplete, error in
                if let error = error {
                    print("Error receiving data: \(error.localizedDescription)")
                    continuation.resume(returning: "")
                    return
                }

                if let data = data, !data.isEmpty {
                    let responseString = String(data: data, encoding: .utf8) ?? ""
                    print("Response received: \(responseString)")
                    continuation.resume(returning: responseString)
                }

                if isComplete {
                    self.connection?.cancel()
                    continuation.resume(returning: "Complete")
                }
            }
        }
    }

    func login(username: String, password: String) async -> String {
        let message = "LOGIN \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }
        
        let response = await receive()
        return response
    }

    func register(name: String, surname: String, username: String, password: String) async -> String {
        let message = "ADD_USER \(name) \(surname) \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            print("Sendig \(message)")
            send(data: messageData)
        }
        
        let response = await receive()
        return response
    }
    
    func requestBookCatalog() async -> String {
        let message = "GET_BOOKS"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }
        
        let responseString = await receive()
        parseReceivedData(responseString)
        return responseString
    }
    
    func requestBook(isbn: String) async -> Book? {
        let message = "GET_BOOK \(isbn)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }
        
        let responseString = await receive()
        return parseReceivedBook(responseString)
    }

    private func parseReceivedBook(_ responseString: String) -> Book? {
        print("Received JSON string: \(responseString)")
        if let data = responseString.data(using: .utf8) {
            do {
                let book = try JSONDecoder().decode(Book.self, from: data)
                DispatchQueue.main.async {
                    self.bookParsed = book
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        return nil
    }

    private func parseReceivedData(_ responseString: String) {
        print("Received JSON string: \(responseString)")
        if let data = responseString.data(using: .utf8) {
            do {
                let books = try JSONDecoder().decode([Book].self, from: data)
                DispatchQueue.main.async {
                    self.bookCatalog = books
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
    }
    
    func loan(username: String, books: String) async -> String {
        let message = "LOAN \(username) \(books)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }
        
        let response = await receive()
        return response
    }
    
    
    func checkNotifications(for username: String) async {
        let message = "CHECK_NOTIFICATIONS \(username)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }

        let responseString = await receive()
        parseNotifications(responseString)
    }

    private func parseNotifications(_ responseString: String) {
        print("Received Notifications JSON: \(responseString)")
        if let data = responseString.data(using: .utf8) {
            do {
                let notifications = try JSONDecoder().decode([Notification].self, from: data)
                DispatchQueue.main.async {
                    self.notifications = notifications
                }
            } catch {
                print("Error decoding Notifications JSON: \(error)")
            }
        }
    }

    func requestUserProfile(username: String) async -> User? {
        let message = "GET_USER \(username)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }

        let responseString = await receive()
        return parseReceivedUser(responseString)
    }

    private func parseReceivedUser(_ responseString: String) -> User? {
        print("Received User JSON string: \(responseString)")
        if let data = responseString.data(using: .utf8) {
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                return user
            } catch {
                print("Error decoding User JSON: \(error)")
            }
        }
        return nil
    }

    func requestUserLoans(username: String) async -> [Loan]? {
        let message = "GET_LOANS \(username)"
        if let messageData = message.data(using: .utf8) {
            print("Sending \(message)")
            send(data: messageData)
        }

        let responseString = await receive()
        return parseReceivedLoans(responseString)
    }

    private func parseReceivedLoans(_ responseString: String) -> [Loan]? {
        print("Received Loans JSON string: \(responseString)")
        if let data = responseString.data(using: .utf8) {
            do {
                let loans = try JSONDecoder().decode([Loan].self, from: data)
                return loans
            } catch {
                print("Error decoding Loans JSON: \(error)")
            }
        }
        return nil
    }
}

/*COMMAND LIST
 ADD_USER name surname username password
 LOGIN username password
 LOAN username isbn1 isbn2 isbn3...
 GET_BOOKS
 GET_BOOK isbn
 CHECK_NOTIFICATIONS username
 GET_USER username
 GET_LOANS username
 */
