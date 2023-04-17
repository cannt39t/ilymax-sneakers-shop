//
//  ChatPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import UIKit


class ConversationsPresenter {
    
    var view: ConversationsViewController?
    var open: (() -> ()) = {}
    
    
    // let chatService: ChatService = ChatService()
    
    func fetchConversations() {
        
    }
    
    func openChat() {
        open()
    }
    
    
}
