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
    
    func changeNotification(nameNotifcation: String, value: Bool) {
        UserDefaults.standard.setValue(value, forKey: nameNotifcation)
    }
    
    func getCurrentState(for nameNotifcation: String) -> Bool {
        if let value = UserDefaults.standard.object(forKey: nameNotifcation) as? Bool {
            return value
        } else {
            changeNotification(nameNotifcation: nameNotifcation, value: false)
            return false
        }
    }
}
