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
    
    public var back: () -> () = {}
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
    func backButtonTap() {
        back()
    }
    
}
