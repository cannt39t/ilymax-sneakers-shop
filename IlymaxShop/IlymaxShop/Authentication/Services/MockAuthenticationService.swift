//
//  MockAuthenticationService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation
import Combine

class MockAuthenticationService: AuthenticationService {
    
    public static let shared = MockAuthenticationService()
    
    private var user: User?
    private var _isAuthorized: CurrentValueSubject<Bool, Never> = .init(false)

    var isAuthorized: AnyPublisher<Bool, Never> {
        _isAuthorized
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    func register(name: String, email: String, password: String) {
        let user = User(name: name, email: email, password: password)
        MockUserService.shared.addUser(user: user)
        self.user = user
        _isAuthorized.value = true
    }
    
    func login(user: User) {
        
        _isAuthorized.value = true
    }
    
    func getUser() -> User? {
        return user
    }
}
