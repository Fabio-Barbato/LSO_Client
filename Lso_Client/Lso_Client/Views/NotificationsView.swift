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
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(notifications) { notification in
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
                        .padding(.horizontal)
                    }
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
