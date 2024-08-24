//
//  Loan.swift
//  Lso_Client
//
//  Created by Fabio Barbato on 24/08/24.
//

import Foundation

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
