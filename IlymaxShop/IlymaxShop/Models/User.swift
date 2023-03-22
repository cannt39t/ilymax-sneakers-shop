//
//  User.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

class User {
    
    public var name: String
    public var email: String
    public var password: String
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
}
