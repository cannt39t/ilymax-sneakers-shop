//
//  DateFormatterExtension.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation

extension DateFormatter {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
}

extension DateFormatter {
    
    static let conversationListFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "dd MMM. yyyy г., h:mm:ss a zzz"
        return formatter
    }()
    
    func conversationListFormattedString(from dateString: String) -> String? {
        print(dateString)
        guard let date = self.date(from: dateString) else {
            return nil
        }
        
        if Calendar.current.isDateInToday(date) {
            self.dateFormat = "h:mm a"
            return self.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            // Yesterday's date, so return "Yesterday"
            return "Yesterday"
        } else {
            // Older date, return the date in the format "dd MMM yyyy"
            self.dateFormat = "dd MMM yyyy"
            return self.string(from: date)
        }
    }
}

