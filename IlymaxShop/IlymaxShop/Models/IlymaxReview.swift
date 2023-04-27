//
//  IlymaxReview.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 24.04.2023.
//

import Foundation

struct IlymaxReview: FirestoreCollectionProtocol {
    
    
    static var collectionName: String = "reviews"
    
    let id: UUID = UUID()
    let text: String
    let rate: Int
    let authorId: String
    let shoesId: String
    let date: Date
}
