//
//  ProfileView.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import SwiftUI

struct LoansView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State private var loans: [Loan] = []
    var username: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Loans")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color("Color"))
                            .padding(.bottom, 20)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)

                if loans.isEmpty {
                    Text("You have no loans.")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.top, 50)
                }else{
                    List(loans) { loan in
                        LoanRow(loan: loan)
                }
                .listStyle(InsetGroupedListStyle())
                }

                Spacer()
            }
            .onAppear {
                Task {
                    await fetchUserLoans()
                }
            }
        }
    }
    
    func fetchUserLoans() async {
        if let fetchedLoans = await networkManager.requestUserLoans(username: username) {
            loans = fetchedLoans
        }
    }
}


