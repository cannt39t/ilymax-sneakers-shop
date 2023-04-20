//
//  ChatViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    
    var presenter: ChatPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.otherUser.name
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        messagesCollectionView.reloadData()
    }
    
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = presenter.selfSender, let messageID = presenter.createMessageID() else {
            return
        }
        let message = Message(sender: selfSender,
                              messageId: messageID,
                              sentDate: Date(),
                              kind: .text(text))
        if presenter.isNewConversation {
            presenter.sendFirstMessage(message: message)
        } else {
            // append to existing conversation data
            presenter.sendMessage(message)
        }
    }
}


extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentSender: MessageKit.SenderType {
        if let sender = presenter.selfSender {
            return sender
        }
        fatalError("Self sender is nil, email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return presenter.messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        presenter.messages.count
    }
}
