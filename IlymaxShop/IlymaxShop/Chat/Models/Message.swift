//
//  Message.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.04.2023.
//

import Foundation
import MessageKit

struct Message: MessageType {
    
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
