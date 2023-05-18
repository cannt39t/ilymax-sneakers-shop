//
//  AddAddressService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 17.05.2023.
//

import Foundation
import FirebaseAuth

class AddAddressService {
    
    func addAddress(_ address: IlymaxAddress, completion: @escaping (Bool) -> Void) {
        let userId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.addAddressFor(userID: userId, address: address) { isAdded in
            completion(isAdded)
        }
    }
}
