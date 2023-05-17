//
//  IlymaxAddress.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.05.2023.
//

import Foundation

struct IlymaxAddress: FirestoreCollectionProtocol {
    
    static var collectionName: String = "addresses"
    
    var fullName: String
    var address: String
    var zipcode: Int
    var country: String
    var city: String
    
}
