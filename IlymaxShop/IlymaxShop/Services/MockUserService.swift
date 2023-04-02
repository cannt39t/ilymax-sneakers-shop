//
//  MockUserService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//





import Foundation

class MockUserService: UserService {
    
    public static let shared = MockUserService()
    
    private var users: [User] = []
    
    public func getUserByEmail(email: String) -> User? {
        return users.first { $0.email == email }
    }
    
    public func addUser(user: User) {
        users.append(user)
        print("User added")
    }
}
