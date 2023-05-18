//
//  AddAddressPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.05.2023.
//

import UIKit


class AddAddressPresenter {
    
    weak var view: AddAddressViewController?
    private let addressesService = AddAddressService()
    
    public func addAddress(_ address: IlymaxAddress) {
        addressesService.addAddress(address) { [weak self] added in
            if added {
                self?.view?.navigationController?.popViewController(animated: true)
            } else {
                print("Didnt add")
            }
        }
    }
}

