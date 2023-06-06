//
//  AuthenticationService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

protocol AuthenticationService {
    
    func register(name: String, email: String, password: String, completion: @escaping ((Error?) -> Void))
    func login(email: String, password: String, completion: @escaping ((Error?) -> Void))
    
}
