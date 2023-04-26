//
//  ReviewAddingPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 25.04.2023.
//

import UIKit

class ReviewAddingPresenter {
    weak var view: ReviewAddingViewController?
    var shoeID: String = ""
    var authorID = ""
    public var popAdd: () -> Void = {}
    
    private var reviewService = ReviewService()
    
    func addReview(review: IlymaxReview){
        reviewService.addReview(review: review)
        popAdd()
    }
}
