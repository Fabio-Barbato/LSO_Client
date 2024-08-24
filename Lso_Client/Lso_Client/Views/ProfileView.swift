//
//  ProfileView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var user: User?
    @State private var loans: [Loan] = []
    @State private var profileFetched = false
    var username: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // User Info
                if let user = user {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Profile")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("Color"))
                            .padding(.bottom, 20)
                        
                        HStack {
                            Text("Name:")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                            Text("\(user.name) \(user.surname)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Username:")
                                .font(.headline)
                                .foregroundColor(Color("TextColor"))
                            Text(user.username)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                } else {
                    ProgressView()
                        .frame(width: 60, height: 90)
                }

                // Loans List
                VStack(alignment: .leading, spacing: 10) {
                    Text("Loans")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Color"))
                        .padding(.bottom, 10)
                    
                    List(loans) { loan in
                        LoanRow(loan: loan)
                    }
                    .listStyle(InsetGroupedListStyle())
                }

                Spacer()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Profile")
            .onAppear {
                Task {
                    if (!profileFetched) {
                        await fetchUserProfile()
                        await fetchUserLoans()
                        profileFetched = true
                    }
                }
            }
        }
    }
    
    func fetchUserProfile() async {
        if let fetchedUser = await networkManager.requestUserProfile(username: username) {
            user = fetchedUser
        }
    }
    
    func fetchUserLoans() async {
        if let fetchedLoans = await networkManager.requestUserLoans(username: username) {
            loans = fetchedLoans
        }
    }
}

struct LoanRow: View {
    var loan: Loan

    var body: some View {
        HStack(alignment: .top){
            AsyncImage(url: URL(string: loan.cover)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
                    .frame(width: 60, height: 90)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(loan.title)
                    .font(.headline)
                    .foregroundColor(Color("TextColor"))
                
                HStack {
                    Text("Loan date:")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(formattedDate(from: loan.loan_date))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("Return date:")
                        .font(.footnote)
                        .foregroundColor(loan.isExpired ? .red : .gray)
                    Text(formattedDate(from: loan.return_date))
                        .font(.footnote)
                        .foregroundColor(loan.isExpired ? .red : .gray)
                }
            }
        }
    }
    
    private func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"  // Specifica il formato delle date ricevute
        guard let date = formatter.date(from: dateString) else { return "N/A" }
        formatter.dateStyle = .medium  // Imposta il formato desiderato per la visualizzazione
        return formatter.string(from: date)
    }
}

struct User: Codable {
    let name: String
    let surname: String
    let username: String
    let password: String
}

struct Loan: Identifiable, Codable {
    let username: String
    let isbn: String
    let loan_date: String
    let return_date: String
    let title: String  
    let cover: String

    var id: String {
        return "\(username)-\(isbn)-\(loan_date)"
    }

    static func == (lhs: Loan, rhs: Loan) -> Bool {
        return lhs.username == rhs.username && lhs.isbn == rhs.isbn && lhs.loan_date == rhs.loan_date
    }

    var isExpired: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        guard let returnDate = formatter.date(from: return_date) else { return false }
        return returnDate < Date()
    }
}
