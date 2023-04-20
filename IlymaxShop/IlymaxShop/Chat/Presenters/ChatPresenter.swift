//
//  ChatPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation

class ChatPresenter {
    
    weak var view: ChatViewController?
    let chatService: ChatService = ChatService()
    var otherUser: IlymaxUser
    
    private var conversationID: String?
    
    var currentUserEmailAddress: String = {
        guard let email = UserDefaults.standard.string(forKey: "currentUserEmail") else {
            fatalError("User should have email here")
        }
        
        return email
    }()
    
    var currentUserName: String = {
        guard let email = UserDefaults.standard.string(forKey: "currentUserName") else {
            fatalError("User should have name here")
        }
        
        return email
    }()
    
    init(view: ChatViewController? = nil, otherUser: IlymaxUser, conversationID: String? = nil) {
        self.view = view
        self.otherUser = otherUser
        self.conversationID = conversationID
        if conversationID != nil {
            listenForMessages()
        }
    }
    
    func sendFirstMessage(message: Message) {
        chatService.createNewConveration(with: otherUser.emailAddress, name: otherUser.name, fisrtMessage: message) { sent in
            if sent {
                print(sent)
            } else {
                print(sent)
            }
        }
    }
    
    func listenForMessages() {
        chatService.listenForMessages()
    }
    
    func getCurrentDate() -> String? {
        DateFormatter.dateFormatter.string(from: Date())
    }
    
    func createMessageID() -> String? {
        let newID = "\(otherUser.emailAddress)_\(currentUserEmailAddress)_\(getCurrentDate()!)"
        print(newID)
        return newID
    }

}
