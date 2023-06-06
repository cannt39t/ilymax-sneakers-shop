//
//  DateFormatterExtension.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation

extension DateFormatter {
    
    public static let dateFormatter = ISO8601DateFormatter()
    
}

extension DateFormatter {
    
    static let messageFromatter = DateFormatter()
    
    static func conversationListFormattedString(from date: Date) -> String? {
        if Calendar.current.isDateInToday(date) {
            messageFromatter.dateFormat = "h:mm a"
            return messageFromatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            messageFromatter.dateFormat = "dd MMM yyyy"
            return messageFromatter.string(from: date)
        }
    }
}

