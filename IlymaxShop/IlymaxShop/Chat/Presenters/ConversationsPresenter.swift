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
    
    func fetchConversations() {
        
    }
    
    func openChat(conversation: Conversation) {
        open(conversation)
    }
    

    func startListeningForConversations() {
        conversationsService.startListeningForConversations { result in
            switch result {
                case .failure(let error):
                    print(error)
                case.success(let conversations):
                    print(conversations)
                    self.conversations = conversations
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.tableView.reloadData()
                    }
            }
        }
    }
    
}
