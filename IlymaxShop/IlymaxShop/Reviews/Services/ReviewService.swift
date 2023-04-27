//
//  ReviewService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 25.04.2023.
//

import Foundation

class ReviewService {
    func addReview(review: IlymaxReview){
        FirestoreManager.shared.insertReview(review) { result in
            switch result {
            case .success(let documentId):
                print(documentId)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUser(userID: String, completion: @escaping (IlymaxUser?) -> Void) {
        FirestoreManager.shared.getUser(with: userID) { user in
            if let user = user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
}
