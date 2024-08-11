import Foundation
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let host_ip = "192.168.1.116"
    private let host = NWEndpoint.Host("192.168.1.116")
    private let port = NWEndpoint.Port(rawValue: 8080)!
    private var connection: NWConnection?

    private init() {
        connectToServer()
    }

    private func connectToServer() {
        connection = NWConnection(host: host, port: port, using: .tcp)
        connection?.start(queue: .global())
        receive()
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

    func receive() {
        connection?.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, isComplete, error in
            if let error = error {
                print("Error receiving data: \(error.localizedDescription)")
                return
            }

            if let data = data, !data.isEmpty {
                let responseString = String(data: data, encoding: .utf8) ?? ""
                print("Response received: \(responseString)")
            }

            if isComplete {
                self.connection?.cancel()
            } else {
                self.receive()
            }
        }
    }
    
    func login(username: String, password: String){
        let message = "LOGIN \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            send(data: messageData)
        }
        receive()
    }

    func register(name: String, surname: String, username: String, password: String){
        let message = "LOGIN \(name) \(surname) \(username) \(password)"
        if let messageData = message.data(using: .utf8) {
            send(data: messageData)
        }
        receive()
    }
}
