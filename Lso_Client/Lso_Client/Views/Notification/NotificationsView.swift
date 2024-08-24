//
//  NotificationsView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 23/08/24.
//


import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var notifications: [Notification] = []
    @State private var notificationsFetched = false
    var username: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Notifications")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("Color"))
                    .padding(.top, 40)

                if notifications.isEmpty {
                    Text("You have no notifications.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                } else {
                    List(notifications) { notification in
                        NotificationRow(notification: notification)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .onAppear {
                Task {
                    if(!notificationsFetched){
                        await fetchNotifications()
                    }
                }
            }
        }
    }
    
    func fetchNotifications() async {
        await networkManager.checkNotifications(for: username)

        notifications = networkManager.notifications
        notificationsFetched = true
    }
}
