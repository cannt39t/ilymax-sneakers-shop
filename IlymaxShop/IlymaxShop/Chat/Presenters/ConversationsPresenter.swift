//
//  ConversationsPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import UIKit


class ConversationsPresenter {
    
    var view: ConversationsViewController?
    let conversationsService: ConversationsService = ConversationsService()
    var open: (() -> ()) = {}
    var createNewConversation: (() -> ()) = {}
    
    private var users: [IlymaxUser] = []
    private var hasFetch = false
    
    func fetchConversations() {
        
    }
    
    func openChat() {
        open()
    }
    

    
    
}
