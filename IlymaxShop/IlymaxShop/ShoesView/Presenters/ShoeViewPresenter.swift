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
    
    var startNewConversation: (IlymaxUser) -> Void = {_ in }
    var openExistingConversation: (Conversation) -> Void = { _ in }
    var openExistingDeletedConversation: (IlymaxUser, String) -> Void = { (_, _) in }
    
    public var pushReview: ([IlymaxReview], String, String) -> Void = {_,_,_  in }
    public var pushSellerView: ([Shoes], IlymaxUser) -> Void = {_,_ in }
    
    var reviews: [IlymaxReview] = []
    var average: Double = 0
    
    
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
        shoeViewService.addItemToCart(userID: FirebaseAuth.Auth.auth().currentUser!.uid, item: cartItem)
    }
    
    func pushSeller() {
        shoeViewService.getAllShoesByUserID(userID: product!.ownerId) {[weak self] shoes in
            DispatchQueue.main.async {
                self?.pushSellerView(shoes, self!.user!)
                self?.view?.hideLoader()
            }
        }
    }
    
    func openChat() {
        shoeViewService.getAllConversations(completion: { [weak self] result in
            switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let existingConversations):
                    if let targetUser = self?.user {
                        if let targetConveration = existingConversations.first(where: {
                            $0.otherUserEmail == targetUser.emailAddress
                        }) {
                            self?.openExistingConversation(targetConveration)
                        } else {
                            self?.shoeViewService.getConversationForUser(with: targetUser.emailAddress) { [weak self] result in
                                switch result {
                                    case .failure(_):
                                        DispatchQueue.main.async {
                                            self?.startNewConversation(targetUser)
                                        }
                                    case .success(let conversationId):
                                        DispatchQueue.main.async {
                                            self?.openExistingDeletedConversation(targetUser, conversationId)
                                        }
                                }
                            }
                        }
                    }
            }
        })
    }
    
}
