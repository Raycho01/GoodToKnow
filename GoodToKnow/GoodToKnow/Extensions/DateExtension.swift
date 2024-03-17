//
//  DateExtension.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 17.03.24.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = formatter.date(from: self.description) else {
            return ""
        }
        formatter.dateFormat = "dd MMMM yyyy HH'h':mm'm'"
        return formatter.string(from: date)
    }
    
    func dateAndTimeToString(format: String = "dd MMMM yyyy hh:mm a") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
