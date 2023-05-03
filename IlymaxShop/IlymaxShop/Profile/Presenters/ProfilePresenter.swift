//
//  ProfilePresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 11.04.2023.
//

import Foundation
import UIKit


class ProfilePresenter {
    
    weak var view: ProfileViewController?
    private let profileService = ProfileService()
    public static var currentUser: IlymaxUser?
    
    public var showOrdersCoordinator: () -> () = { }
    
    func fetchUser() {
        profileService.getCurrentUser { [weak self] user in
            if let user {
                DispatchQueue.main.async {
                    self?.view?.showUserProfile(with: user)
                    ProfilePresenter.currentUser = user
                }
            } else {
                DispatchQueue.main.async {
                    self?.view?.somethingWentWrong()
                }
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        view?.showLoader()
        profileService.uploadProfileImage(with: image) { [weak self] result in
            switch result {
                case .success(let url):
                    print("Succesfly upload \(url)")
                    UserDefaults.standard.set(url, forKey: "profile_picture")
                    self?.view?.hideLoader()
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                    self?.view?.hideLoader()
                    self?.view?.showError(error)
            }
        }
    }
    
    func showMyOrders() {
        showOrdersCoordinator()
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
