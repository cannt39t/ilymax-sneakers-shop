//
//  Conversation.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.04.2023.
//

import Foundation

struct Conversation {
    
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
    
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}


extension Conversation {
    static func fromDictionary(_ dictionary: [String: Any]) -> Conversation? {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let otherUserEmail = dictionary["other_user_email"] as? String,
              let latestMessageData = dictionary["latest_message"] as? [String: Any],
              let latestMessage = LatestMessage.fromDictionary(latestMessageData) else {
            return nil
        }

        return Conversation(id: id, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessage)
    }
}

extension LatestMessage {
    static func fromDictionary(_ dictionary: [String: Any]) -> LatestMessage? {
        guard let date = dictionary["date"] as? String,
              let text = dictionary["message"] as? String,
              let isRead = dictionary["is_read"] as? Bool else {
            return nil
        }

        return LatestMessage(date: date, text: text, isRead: isRead)
    }
}
