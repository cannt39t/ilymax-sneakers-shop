//
//  UserService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

protocol UserService {
    
    func getUserByEmail(email: String) -> User?
    func addUser(user: User)
    
}
