//
//  IlymaxUser.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

struct IlymaxUser {
    
    let name: String
    let emailAddress: String
    let profilePictureUrl: String?
    
    var safeEmail: String {
        return Security.getSafeEmail(email: emailAddress)
    }
}
