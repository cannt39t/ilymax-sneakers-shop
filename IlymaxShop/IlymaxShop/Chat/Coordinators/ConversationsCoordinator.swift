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
    
    func openChat(conversation: Conversation) {
        let chatController = ChatViewController()
        let chatPresenter = ChatPresenter(otherUser: IlymaxUser(name: conversation.name, emailAddress: conversation.otherUserEmail, profilePictureUrl: nil), conversationID: conversation.id )
        
        chatController.presenter = chatPresenter
        chatPresenter.view = chatController
        
        navigationController.pushViewController(chatController, animated: true)
    }
    
    func newConversation() {
        let newConversationControler = NewConversationViewController()
        let newConversationPresenter = NewConversationPresenter()
        
        
        newConversationPresenter.startNewConversation = { [weak self] result in
            self?.navigationController.dismiss(animated: false)
            print(result)
            self?.createNewConvesation(with: result)
        }
        
        newConversationControler.presenter = newConversationPresenter
        newConversationPresenter.view = newConversationControler
        
        let navController = UINavigationController(rootViewController: newConversationControler)
        navigationController.present(navController, animated: true)
    }
    
    private func createNewConvesation(with user: IlymaxUser) {
        let chatController = ChatViewController()
        let chatPresenter = ChatPresenter(otherUser: user)
        
        chatController.presenter = chatPresenter
        chatPresenter.view = chatController
        
        
        chatController.isNewConversation = true
        navigationController.pushViewController(chatController, animated: true)
    }
    
}
