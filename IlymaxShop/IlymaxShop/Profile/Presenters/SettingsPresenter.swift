//
//  SettingsPresenter.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import Foundation


class SettingsPresenter {
    
    weak var view: SettingsController?
    private let settingsService = SettingsService()
    public var currentUser: IlymaxUser
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
    public func clearCache() {
        settingsService.clearCache { [weak self] in
            self?.view?.showSucces()
        }
    }
    
    public func signOut() {
        settingsService.signOut()
    }
    
    public func changeState(for name: String, value: Bool) {
        settingsService.changeNotification(nameNotifcation: name, value: value)
    }
    
    public func getState(for name: String) -> Bool {
        return settingsService.getCurrentState(for: name)
    }
}
