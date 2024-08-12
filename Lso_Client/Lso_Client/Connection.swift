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
            connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, isComplete, error in
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
            send(data: messageData)
        }
        
        let response = await receive()
        return response
    }

    func register(name: String, surname: String, username: String, password: String) async -> String {
        let message = "ADD_USER \(name) \(surname) \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            send(data: messageData)
        }
        
        let response = await receive()
        return response
    }
    
    func requestBookCatalog() async -> String {
        let message = "GET_BOOKS"
        if let messageData = message.data(using: .utf8) {
            send(data: messageData)
        }
        
        let responseString = await receive()
        parseReceivedData(responseString)
        return responseString
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
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
    }
}

struct Book: Identifiable, Codable {
    var id: String { ISBN }
    let title: String
    let ISBN: String
    let author: String
    let genre: String
    let copies: Int
    let given_copies: Int
}

/*COMMAND LIST
 ADD_USER name surname username password
 LOGIN username password
 LOAN username isbn1 isbn2 isbn3...
 GET_BOOKS
 */
