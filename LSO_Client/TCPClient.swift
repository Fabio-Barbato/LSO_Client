import Foundation
import Network

let host_ip = "192.168.1.116"

func connectToServer() {
    let host = NWEndpoint.Host(host_ip)
    let port = NWEndpoint.Port(rawValue: 8080)!

    let connection = NWConnection(host: host, port: port, using: .tcp)

    connection.start(queue: .global())

    func send(data: Data) {
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Error sending data: \(error.localizedDescription)")
                return
            }
            print("Data sent")
        })
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

            if isComplete {
                connection.cancel()
            } else {
                receive()
            }
        }
    }

    let message = "LOGIN Raziel2 new_passwd"
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
