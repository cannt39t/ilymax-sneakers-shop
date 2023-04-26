//
//  ShoeViewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import UIKit

class ShoeViewPresenter {
    weak var view: ShoeViewController?
    private let shoeViewService = ShoeViewService()
    var product: Shoes?
    public var pushReview: ([IlymaxReview], String) -> Void = {_,_  in }
    
    var reviews: [IlymaxReview] = []
    var average: Double = 0
    
    func loadImage() {
        guard let product = product else { return }
        
        shoeViewService.getImage(for: product) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.updateImage(with: image)
            }
        }
    }
    
    func loadReviews() {
        shoeViewService.getReviewsByShoesId((product?.id)!) {[weak self] result in
            switch result {
                case .success(let reviews):
                self?.reviews =  reviews
                if reviews.count != 0 {
                    let totalRate = reviews.reduce(0, { $0 + $1.rate })
                    self?.average = (Double(totalRate) / Double(reviews.count) * 100).rounded(.toNearestOrEven) / 100
                }
                DispatchQueue.main.async { [weak self] in
                    self?.view?.setupUI()
                    self?.view?.hideLoader()
                }
            case .failure(let error):
                print(error )
            }
        }
    }
    
    func pushReviews() {
        pushReview(reviews, (product?.id)!)
    }
    
}
