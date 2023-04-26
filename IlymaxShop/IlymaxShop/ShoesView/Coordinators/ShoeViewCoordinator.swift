//
//  ShoeViewCoordinator.swift
//  IlymaxShop
//
//  Created by Максим Тарасов on 24.04.2023.
//

import UIKit

class ShoeViewCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start(product: Shoes) {
        let shoeViewController = ShoeViewController()
        let shoeViewPresenter = ShoeViewPresenter()
        shoeViewPresenter.pushReview = pushReviews
        shoeViewPresenter.view = shoeViewController
        shoeViewController.presenter = shoeViewPresenter
        shoeViewPresenter.product = product
        navigationController.pushViewController(shoeViewController, animated: true)
    }
    
    func pushReviews(reviews: [IlymaxReview], shoeID: String) {
        let reviewController = ReviewViewController()
        let presenter = ReviewPresenter()
        presenter.pushAdd = pushAddReview
        presenter.popAdd = popViewController
        reviewController.presenter = presenter
        presenter.reviews = reviews
        presenter.shoeID = shoeID
        presenter.view = reviewController
        navigationController.pushViewController(reviewController, animated: true)
    }
    
    func pushAddReview(shoeId: String, authorId: String) {
        let reviewAddingViewController = ReviewAddingViewController()
        let presenter = ReviewAddingPresenter()
        reviewAddingViewController.presenter = presenter
        presenter.authorID = authorId
        presenter.shoeID = shoeId
        presenter.popAdd = popViewController
        presenter.view = reviewAddingViewController
        navigationController.pushViewController(reviewAddingViewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
}
