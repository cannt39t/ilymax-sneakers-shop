//
//  AddressesPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation


class AddressesPresenter {
    
    weak var view: AddressesCollectionViewController?
    private let addressesService = AddressesService()
    public var currentUser: IlymaxUser
    public var addresses: [IlymaxAddress] = []
    
    public var back: () -> () = {}
    public var pushAddAddressController: () -> () = {}
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
    
    public func getAddresses() {
        view?.showLoader()
        addressesService.getAddreeses { [weak self] result in
            switch result {
                case .success(let addresses):
                    self?.view?.hideLoader()
                    self?.addresses = addresses
                    if addresses.count == 0 {
                        self?.view?.noAddressesView.isHidden = false
                    } else {
                        self?.view?.noAddressesView.isHidden = true
                        self?.view?.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func backButtonTap() {
        back()
    }
    
}
