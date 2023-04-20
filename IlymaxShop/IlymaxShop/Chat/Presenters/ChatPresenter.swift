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
    
    public var selfSender: Sender? {
        return Sender(photoURL: "", senderId: currentUserEmailAddress, displayName: "Me")
    }
    
    private var conversationID: String?
    public var messages = [Message]()
    public var isNewConversation = false
    
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
        if let id = conversationID {
            listenForMessages(id: id)
        }
    }
    
    func sendFirstMessage(message: Message) {
        conversationID = "conversation_\(message.messageId)"
        listenForMessages(id: conversationID!)
        chatService.createNewConveration(with: otherUser.emailAddress, name: otherUser.name, fisrtMessage: message) { [weak self] sent in
            if sent {
                print(sent)
                self?.isNewConversation = false
            } else {
                print(sent)
            }
        }
    }
    
    func listenForMessages(id: String) {
        chatService.listenForMessages(for: conversationID!) { [weak self] result in
            switch result {
                case .success(let messages):
                    guard !messages.isEmpty else {
                        return
                    }
                    self?.messages = messages
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.messagesCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getCurrentDate() -> String? {
        DateFormatter.dateFormatter.string(from: Date())
    }
    
    func createMessageID() -> String? {
        let newID = "\(otherUser.emailAddress)_\(currentUserEmailAddress)_\(getCurrentDate()!)"
        return newID
    }
    
    func sendMessage(_ message: Message) {
        guard let id = conversationID else {
            return
        }
        chatService.sendMessage(to: id, email: otherUser.emailAddress, message: message) { sent in
            if sent {
                print("New message sent")
            } else {
                print("New message no sent")
            }
        }
    }

}
