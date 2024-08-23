//
//  Notifications.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 23/08/24.
//

import Foundation

struct Notification: Identifiable, Codable {
    let username: String
    let isbn: String
    let message: String
    var notified: Bool
    
    var id: String {
        return "\(username)-\(isbn)"
    }
    
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.username == rhs.username && lhs.isbn == rhs.isbn
    }
}
