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
    public var currentUser: IlymaxUser?
    
    public var countAddresses: Int = 0
    public var countOrders: Int = 0
    public var countSaleList: Int = 0
    
    public var showOrdersCoordinator: (IlymaxUser) -> () = { _ in }
    public var showSettingsCoordinator: (IlymaxUser) -> () = { _ in }
    public var showAddressesCoordinator: (IlymaxUser) -> () = { _ in }
    public var showSalesCoordinator: (IlymaxUser) -> () = { _ in }
    
    
    func fetchUserAndData() {
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        profileService.getSaleListCount { [weak self] result in
            defer { group.leave() }
            
            switch result {
                case .success(let count):
                    self?.countSaleList = count
                case .failure(let error):
                    print(error)
            }
        }
        

        profileService.getAdressCount { [weak self] result in
            defer { group.leave() }
            
            switch result {
                case .success(let count):
                    self?.countAddresses = count
                case .failure(let error):
                    print(error)
            }
        }
        
        profileService.getCurrentUser { [weak self] user in
            defer { group.leave() }
            
            if let user = user {
                DispatchQueue.main.async {
                    self?.currentUser = user
                }
            } else {
                DispatchQueue.main.async {
                    self?.view?.somethingWentWrong()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.showUserProfile(with: (self?.currentUser)!)
        }
    }
    
    func fetchUser() {
        profileService.getCurrentUser { [weak self] user in
            if let user {
                DispatchQueue.main.async {
                    self?.view?.showUserProfile(with: user)
                    self?.currentUser = user
                }
            } else {
                DispatchQueue.main.async {
                    self?.view?.somethingWentWrong()
                }
            }
        }
    }
    
    func getListingsForSale() {
        profileService.getSaleListCount { [weak self] result in
            switch result {
                case .success(let count):
                    self?.countSaleList = count
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func getAddresses() {
        profileService.getSaleListCount { [weak self] result in
            switch result {
                case .success(let count):
                    self?.countAddresses = count
                case .failure(let error):
                    print(error)
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
        guard let user = currentUser else {
            fatalError("No way that this happens")
        }
        showOrdersCoordinator(user)
    }
    
    func showMySettings() {
        guard let user = currentUser else {
            fatalError("No way that this happens")
        }
        showSettingsCoordinator(user)
    }
    
    func showMySales() {
        guard let user = currentUser else {
            fatalError("No way that this happens")
        }
        showSalesCoordinator(user)
    }
    
    func showMyAddresses() {
        guard let user = currentUser else {
            fatalError("No way that this happens")
        }
        showAddressesCoordinator(user)
    }
    
    // TODO: Replace these functions on real ones from servies
    
    func getOrders() {
        
    }
    
}
