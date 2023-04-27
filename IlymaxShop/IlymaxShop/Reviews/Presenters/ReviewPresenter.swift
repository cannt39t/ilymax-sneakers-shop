//
//  ReviewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 24.04.2023.
//

import FirebaseAuth
import UIKit


class ReviewPresenter {
    
    weak var view: ReviewViewController?
    var reviews: [IlymaxReview] = []
    var authors: [String] = []
    var pictureURL: [String?] = []
    var shoeID: String = ""
    var authorID = FirebaseAuth.Auth.auth().currentUser!.uid
    public var popAdd: () -> Void = {}
    public var pushAdd: (String, String) -> Void = {_, _ in}
    
    private var reviewService = ReviewService()
    
    func pushAdding() {
        pushAdd(shoeID, authorID)
    }
    
    func loadUsers() {
        if reviews.count != 0 {
            var loadedUserCount = 0
            
            for review in reviews {
                reviewService.getUser(userID: review.authorId) { [weak self] user in
                    guard let self = self else { return }
                    
                    self.authors.append(user!.name)
                    self.pictureURL.append(user?.profilePictureUrl)
                    loadedUserCount += 1
                    
                    if loadedUserCount == self.reviews.count {
                        self.view?.hideLoader()
                        self.view?.setupUI()
                    }
                }
            }
        } else {
            self.view?.hideLoader()
            self.view?.setupUI()
        }
   }
}
