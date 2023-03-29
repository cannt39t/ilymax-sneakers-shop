//
//  Security.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 28.03.2023.
//

import Foundation

class Security {
    
    public static func getSafeEmail(email: String) -> String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
