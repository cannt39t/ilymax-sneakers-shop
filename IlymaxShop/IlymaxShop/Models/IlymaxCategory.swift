//
//  IlymaxCategory.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 03.04.2023.
//

import Foundation


struct IlymaxCategory: FirestoreCollectionProtocol {
    
    static var collectionName: String = "categories"
    
    let name: String
    let imageUrl: String
    
}
