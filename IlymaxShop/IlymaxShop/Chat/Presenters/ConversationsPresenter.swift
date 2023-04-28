//
//  ConversationsPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import UIKit


class ConversationsPresenter {
    
    weak var view: ConversationsViewController?
    let conversationsService: ConversationsService = ConversationsService()
    var open: ((Conversation) -> ()) = { _ in }
    var createNewConversation: (() -> ()) = {}
    
    public var conversations = [Conversation]()
    private var hasFetch = false
    
    func openChat(conversation: Conversation) {
        open(conversation)
    }
    

    func startListeningForConversations() {
        conversationsService.startListeningForConversations { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error)
                case.success(let conversations):
                    self?.conversations = conversations
                    print(conversations.count)
                    if conversations.count != 0 {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.tableView.isHidden = false
                            self?.view?.noConversationsLabel.isHidden = true
                            self?.view?.tableView.reloadData()
                        }
                    } else {
                        DispatchQueue.main.async { [weak self] in
                            self?.view?.noConversationsLabel.isHidden = false
                            self?.view?.tableView.isHidden = true
                        }
                    }
            }
        }
    }
    
    func deleteConversation(conversationId: String, indexPath: IndexPath) {
        conversationsService.deleteConversation(coversationId: conversationId) { [weak self] result in
            
        }
    }
    
}
