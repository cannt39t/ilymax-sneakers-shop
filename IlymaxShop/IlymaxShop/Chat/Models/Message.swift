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
