//
//  NotificationRow.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import SwiftUI

struct NotificationRow: View {
    var notification: Notification
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(notification.notified ? .gray : .yellow)
                .font(.title)

            VStack(alignment: .leading, spacing: 5) {
                Text(notification.message)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
