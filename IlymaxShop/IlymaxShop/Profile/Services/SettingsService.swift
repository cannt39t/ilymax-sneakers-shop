//
//  SettingsService.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation
import SDWebImage
import FirebaseAuth


class SettingsService {
    
    func clearCache(completion: @escaping () -> ()) {
        let cache = SDImageCache.shared
        cache.clearMemory()
        cache.clearDisk {
            completion()
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
}
