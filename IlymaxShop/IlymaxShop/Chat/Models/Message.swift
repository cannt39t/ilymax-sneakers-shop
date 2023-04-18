//
//  Message.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation
import MessageKit

struct Message: MessageType {
    
    public var sender: MessageKit.SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKit.MessageKind
    
}

extension MessageKind {
    var messageKindString: String {
        switch self {
            case .text(_):
                return "text"
            case .attributedText(_):
                return "attributed_text"
            case .photo(_):
                return "photo"
            case .video(_):
                return "video"
            case .location(_):
                return "location"
            case .emoji(_):
                return "emoji"
            case .audio(_):
                return "audio"
            case .contact(_):
                return "contact"
            case .linkPreview(_):
                return "link_preview"
            case .custom(_):
                return "custom"
        }
    }
}
