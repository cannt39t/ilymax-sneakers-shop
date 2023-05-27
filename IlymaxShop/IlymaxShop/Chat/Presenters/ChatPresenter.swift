//
//  ChatPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 18.04.2023.
//

import Foundation
import UIKit
import CoreLocation

class ChatPresenter {
    
    weak var view: ChatViewController?
    let chatService: ChatService = ChatService()
    var otherUser: IlymaxUser
    var conversation: Conversation!
    
    public var selfSender: Sender? {
        return Sender(photoURL: "", senderId: currentUserEmailAddress, displayName: "Me")
    }
    
    private var conversationID: String?
    public var messages = [Message]()
    public var isNewConversation = false
    
    public var openImageCoordinator: (URL) -> () = { _ in }
    public var openVideoCoordinator: (URL) -> () = { _ in }
    public var showPickerLocationCoordinator: (@escaping (CLLocationCoordinate2D) -> ()) -> () = { _ in }
    public var openLocationCoordinator: (CLLocationCoordinate2D) -> () = { _ in }
    
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
//                        let indexPath = IndexPath(item: 0, section: messages.count - 1)
//                        self?.view?.messagesCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
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
        chatService.sendMessage(to: id, email: otherUser.emailAddress, otherUser: otherUser, message: message) { sent in
            if sent {
                print("New message sent")
            } else {
                print("New message no sent")
            }
        }
    }
    
    func uploadPhotoMessage(with data: Data) {
        guard let messageID = createMessageID(), let conID = conversationID, let sender = selfSender else {
            return
        }
        let filename = "photo_message_" + messageID + ".png".replacingOccurrences(of: " ", with: "-")
        chatService.uploadImageDataMessage(imageData: data, filename: filename) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
                case .success(let urlString):
                    guard let url = URL(string: urlString) else {
                        return
                    }
                    let media = Media(url: url, placeholderImage: UIImage(systemName: "photo")!, size: .zero)
                    let message = Message(sender: sender, messageId: messageID, sentDate: Date(), kind: .photo(media))
                    self?.chatService.sendMessage(to: conID, email: strongSelf.otherUser.emailAddress, otherUser: strongSelf.otherUser, message: message) { sent in
                        if sent {
                            
                        } else {
                            
                        }
                    }
                case .failure(let error):
                    print("message could not upload \(error)")
            }
        }
    }
    
    func uploadVideoMessage(with videoUrl: URL) {
        guard let messageID = createMessageID(), let conID = conversationID, let sender = selfSender else {
            return
        }
        let cleanedMessageID = messageID.replacingOccurrences(of: " ", with: "-")
        let filename = "video_message_" + cleanedMessageID + ".mp4"
        chatService.uploadMessageVideoUrl(videoUrl: videoUrl, filename: filename) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
                case .success(let urlString):
                    guard let url = URL(string: urlString) else {
                        return
                    }
                    let media = Media(url: url, placeholderImage: UIImage(systemName: "photo")!, size: .zero)
                    let message = Message(sender: sender, messageId: messageID, sentDate: Date(), kind: .video(media))
                    self?.chatService.sendMessage(to: conID, email: strongSelf.otherUser.emailAddress, otherUser: strongSelf.otherUser, message: message) { sent in
                        if sent {
                            
                        } else {
                            
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func openImage(with url: URL) {
        openImageCoordinator(url)
    }
    
    func openVideo(with url: URL) {
        openVideoCoordinator(url)
    }
    
    
    func showPickerLocation() {
        showPickerLocationCoordinator(getLocation(_:))
    }
    
    private func getLocation(_ selectedCoordinates: CLLocationCoordinate2D) {
        let longitude = selectedCoordinates.longitude
        let latitude = selectedCoordinates.latitude
        
        guard let messageID = createMessageID(), let conID = conversationID, let sender = selfSender else {
            return
        }
        
        let location = Location(location: CLLocation(latitude: latitude, longitude: longitude), size: .zero)
        let message = Message(sender: sender, messageId: messageID, sentDate: Date(), kind: .location(location))
        chatService.sendMessage(to: conID, email: otherUser.emailAddress, otherUser: otherUser, message: message) { sent in
            if sent {
                
            } else {
                
            }
        }
    }
    
    func openLocationWithCoordinates(_ coordinates: CLLocationCoordinate2D) {
        openLocationCoordinator(coordinates)
    }

}
