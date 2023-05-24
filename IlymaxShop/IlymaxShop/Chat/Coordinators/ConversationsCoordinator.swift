//
//  ConversationsCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit
import AVFoundation
import CoreLocation

class ConversationsCoordinator {
    
    var navigationController: UINavigationController!
    
    func start() -> UIViewController {
        let conversationPresenter = ConversationsPresenter()
        conversationPresenter.open = openChat
        conversationPresenter.searchUserForConversation = newConversation
        
        let conversationsController = ConversationsViewController()
        
        conversationPresenter.view = conversationsController
        conversationsController.presenter = conversationPresenter
        navigationController = UINavigationController(rootViewController: conversationsController)
        return navigationController
    }
    
    func newConversation(existingConversations: [Conversation]) {
        let newConversationControler = NewConversationViewController()
        let newConversationPresenter = NewConversationPresenter()
        
        newConversationPresenter.existingConversations = existingConversations
        newConversationPresenter.openExistingConversation = openChat
        newConversationPresenter.startNewConversation = createNewConvesation
        newConversationPresenter.openExistingDeletedConversation = openExistingDeletedConversation
        newConversationPresenter.dismissSearchController = { [weak self] in
            self?.navigationController.dismiss(animated: false)
        }
        
        newConversationControler.presenter = newConversationPresenter
        newConversationPresenter.view = newConversationControler
        
        let navController = UINavigationController(rootViewController: newConversationControler)
        navigationController.present(navController, animated: true)
    }
    
    func openChat(conversation: Conversation) {
        let chatController = ChatViewController()
        let chatPresenter = ChatPresenter(otherUser: IlymaxUser(name: conversation.name, emailAddress: conversation.otherUserEmail, profilePictureUrl: nil), conversationID: conversation.id)
        
        chatController.presenter = chatPresenter
        chatPresenter.openImageCoordinator = openImage
        chatPresenter.openVideoCoordinator = openVideo
        chatPresenter.showPickerLocationCoordinator = openMapToSendLocation
        chatPresenter.openLocationCoordinator = openLocation

        chatPresenter.view = chatController
        
        navigationController.pushViewController(chatController, animated: true)
    }
    
    func openExistingDeletedConversation(with user: IlymaxUser, conversationId: String) {
        let chatController = ChatViewController()
        let chatPresenter = ChatPresenter(otherUser: user, conversationID: conversationId)
        
        chatPresenter.view = chatController
        chatController.presenter = chatPresenter
        
        chatPresenter.openImageCoordinator = openImage
        chatPresenter.openVideoCoordinator = openVideo
        chatPresenter.showPickerLocationCoordinator = openMapToSendLocation
        chatPresenter.openLocationCoordinator = openLocation
        
        navigationController.pushViewController(chatController, animated: true)
    }
    
    func createNewConvesation(with user: IlymaxUser) {
        let chatController = ChatViewController()
        let chatPresenter = ChatPresenter(otherUser: user)
        
        chatController.presenter = chatPresenter
        chatPresenter.view = chatController
        
        chatPresenter.openImageCoordinator = openImage
        chatPresenter.openVideoCoordinator = openVideo
        chatPresenter.showPickerLocationCoordinator = openMapToSendLocation
        chatPresenter.openLocationCoordinator = openLocation

        chatPresenter.isNewConversation = true
        navigationController.pushViewController(chatController, animated: true)
    }
    
    func openImage(with url: URL) {
        let viewer = PhotoViewerViewController(with: url)
        navigationController.pushViewController(viewer, animated: true)
    }
    
    func openVideo(with url: URL) {
        let viewer = VideoViewerViewController()
        viewer.player = AVPlayer(url: url)
        navigationController.present(viewer, animated: true)
    }
    
    func openMapToSendLocation(completion: @escaping (CLLocationCoordinate2D) -> ()) {
        let locationPickerViewContrller = LocationPickerViewController()
        locationPickerViewContrller.isPiackable = true
        locationPickerViewContrller.title = "Pick Location"
        locationPickerViewContrller.completion = completion
        navigationController?.pushViewController(locationPickerViewContrller, animated: true)
    }
    
    func openLocation(_ coordiantes: CLLocationCoordinate2D) {
        let locationPickerViewContrller = LocationPickerViewController(coordinates: coordiantes)
        locationPickerViewContrller.title = "Location"
        navigationController?.pushViewController(locationPickerViewContrller, animated: true)
    }
}
