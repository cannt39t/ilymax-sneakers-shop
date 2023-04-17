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
    
}
