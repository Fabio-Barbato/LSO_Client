//
//  LoanRow.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import SwiftUI

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
        formatter.dateFormat = "dd-MM-yyyy"
        guard let date = formatter.date(from: dateString) else { return "N/A" }
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
