//
//  Connection.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 11/08/24.
//

import Foundation
import Network

private let host_ip = "192.168.1.116"
private let host = NWEndpoint.Host(host_ip)
private let port = NWEndpoint.Port(rawValue: 8080)!
private let connection = NWConnection(host: host, port: port, using: .tcp)

func connectToServer() {
    DispatchQueue.global().async{
        connection.start(queue: .global())
    }
}
func receive() {
    connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, isComplete, error in
        if let error = error {
            print("Error receive data: \(error.localizedDescription)")
            return
        }

        if let data = data, !data.isEmpty {
            let responseString = String(data: data, encoding: .utf8) ?? ""
            print("Response receveid: \(responseString)")
        }

        receive()
    }
}

func send(data: Data) {
    connection.send(content: data, completion: .contentProcessed { error in
        if let error = error {
            print("Error sending data: \(error.localizedDescription)")
            return
        }
        print("Data sent")
    })
}

func login(username: String, password: String){
    let message = "LOGIN \(username) \(password)"
    if let messageData = message.data(using: .utf8) {
        send(data: messageData)
    }
    receive()
}


/* COMMAND LIST
 ADD_USER name surname username password
 LOGIN username password
 LOAN username isbn1 isbn2 isbn3 ...
 */
