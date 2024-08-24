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
                .foregroundColor(Color("Color"))
                .font(.title)

            VStack(alignment: .leading, spacing: 5) {
                Text(notification.message)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
            }
            Spacer()
        }
        .padding()
        .cornerRadius(10)
    }
}
