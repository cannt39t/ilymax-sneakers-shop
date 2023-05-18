//
//  AddressesService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation
import FirebaseAuth

class AddressesService {
    
    func getAddreeses(completion: @escaping (Result<[IlymaxAddress], Error>) -> Void) {
        let userId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.getAddressesListener(for: userId) { result in
            completion(result)
        }
    }
    
    func addAddress(_ address: IlymaxAddress, completion: @escaping (Bool) -> Void) {
        let userId = FirebaseAuth.Auth.auth().currentUser!.uid
        FirestoreManager.shared.addAddressFor(userID: userId, address: address) { isAdded in
            completion(isAdded)
        }
    }
    
}
