//
//  IlymaxOrder.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 31.05.2023.
//

import Foundation


struct IlymaxOrder: FirestoreCollectionProtocol {
    
    static var collectionName: String = "orders"
    
    let id: String
    let date: Date
    let status: String
    let customerId: String
    
    let items: [IlymaxCartItem]
    let address: IlymaxAddress
}
