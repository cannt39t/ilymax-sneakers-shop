//
//  ShoeViewPresenter.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 18.04.2023.
//

import FirebaseAuth
import UIKit

class ShoeViewPresenter {
    weak var view: ShoeViewController?
    private let shoeViewService = ShoeViewService()
    var product: Shoes?
    var sellerName = ""
    var user: IlymaxUser?
    public var pushReview: ([IlymaxReview], String, String) -> Void = {_,_,_  in }
    public var pushSellerView: ([Shoes], IlymaxUser) -> Void = {_,_ in }
    
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
            case .failure(let error):
                print(error )
            }
        }
        
        shoeViewService.getUser(userID: (product?.ownerId)!) { [weak self] user in
            guard let self = self else { return }
            
            self.sellerName = user?.name ?? ""
            self.user = user!
            DispatchQueue.main.async { [weak self] in
                self?.view?.setupUI()
                self?.view?.hideLoader()
            }
        }
    }
    
    func pushReviews() {
        pushReview(reviews, (product?.id)!, product!.ownerId)
    }
    
    func addToCart(cartItem: IlymaxCartItem) {
        if FirebaseAuth.Auth.auth().currentUser?.uid == nil || self.product?.ownerId == FirebaseAuth.Auth.auth().currentUser!.uid{
    
        } else {
            shoeViewService.addItemToCart(userID: FirebaseAuth.Auth.auth().currentUser!.uid, item: cartItem)
        }
    }
    
    func pushSeller() {
        shoeViewService.getAllShoesByUserID(userID: product!.ownerId) {[weak self] shoes in
            DispatchQueue.main.async {
                self?.pushSellerView(shoes, self!.user!)
                self?.view?.hideLoader()
            }
        }
    }
    
}
