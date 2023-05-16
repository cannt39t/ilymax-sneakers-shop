//
//  ShoeViewService.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit
import SDWebImage

class ShoeViewService {
    func getImage(for shoes: Shoes, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = shoes.imageUrl else {
           completion(nil)
           return
       }
       
        StorageManager.shared.getImageUrlFromStorageUrl(imageUrl) { error, url in
           if let error = error {
               // Show error message to user
               print("Error loading image: \(error.localizedDescription)")
               completion(nil)
               return
           }
           
           guard let url = url else {
               completion(nil)
               return
           }
           
           SDWebImageManager.shared.loadImage(with: url, options: [.progressiveLoad, .highPriority], progress: nil) { (image, _, _, _, _, _) in
               completion(image)
           }
       }
   }
    
    func getReviewsByShoesId(_ shoesId: String, completion: @escaping (Result<[IlymaxReview], Error>) -> Void) {
        FirestoreManager.shared.getReviewsByShoesId(shoesId) { result in
            completion(result)
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
    
    func addItemToCart(userID: String, item: IlymaxCartItem) {
        FirestoreManager.shared.addItemToCart(userID: userID, item: item) { success in
            if success {
                print("success")
            } else {
                print("error")
            }
        }
    }
}
