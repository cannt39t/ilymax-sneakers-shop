//
//  ValidationError.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 22.03.2023.
//

import Foundation

class ValidationError: Error {
    
    public enum ValidationErrorType {
        case emptyField
        case invalidEmail
        case shortPassword
        case mismatchedPasswords
        case emailAlreadyInUse
        case invalidPassword
        case cannotFindEmail
    }
    
    public var atIndex: Int
    public var type: ValidationErrorType
    
    init(atIndex: Int, type: ValidationErrorType) {
        self.atIndex = atIndex
        self.type = type
    }
    
    public static func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
