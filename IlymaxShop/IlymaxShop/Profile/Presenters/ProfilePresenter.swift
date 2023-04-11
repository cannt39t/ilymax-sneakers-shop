//
//  ProfilePresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation


class ProfilePresenter {
    
    weak var view: ProfileViewController?
    private let profileService = ProfileService()
    
    func fetchUser() {
        profileService.getCurrentUser { [weak self] user in
            if let user {
                DispatchQueue.main.async {
                    self?.view?.showUserProfile(with: user)
                }
            } else {
                DispatchQueue.main.async {
                    self?.view?.somethingWentWrong()
                }
            }
        }
    }
    
    // TODO: Replace these functions on real ones from servies
    
    func getOrders() -> Int {
        10
    }
    
    func getListingsForSale() -> Int {
        7
    }
    
    func getAddresses() -> Int {
        3
    }
    
}
