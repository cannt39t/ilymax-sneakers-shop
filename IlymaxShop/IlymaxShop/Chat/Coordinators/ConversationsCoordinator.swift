//
//  ConversationsCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class ConversationsCoordinator {
    
    private var navigationController: UINavigationController!
    
    func start() -> UIViewController {
        let conversationPresenter = ConversationsPresenter()
        conversationPresenter.open = openChat
        conversationPresenter.createNewConversation = newConversation
        
        let conversationsController = ConversationsViewController()
        
        conversationPresenter.view = conversationsController
        conversationsController.presenter = conversationPresenter
        navigationController = UINavigationController(rootViewController: conversationsController)
        return navigationController
    }
    
    func openChat() {
        let chatController = ChatViewController()
        navigationController.pushViewController(chatController, animated: true)
    }
    
    func newConversation() {
        let newConversationControler = NewConversationViewController()
        let newConversationPresenter = NewConversationPresenter()
        
        newConversationControler.presenter = newConversationPresenter
        newConversationPresenter.view = newConversationControler
        
        let navController = UINavigationController(rootViewController: newConversationControler)
        navigationController.present(navController, animated: true)
    }
    
}
