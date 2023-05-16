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
    
    public var back: () -> () = {}
    
    init(currentUser: IlymaxUser) {
        self.currentUser = currentUser
    }
    
    func backButtonTap() {
        back()
    }
    
    public func clearCache() {
        settingsService.clearCache { [weak self] in
            self?.view?.showSucces()
        }
    }
    
    public func signOut() {
        settingsService.signOut()
    }
}
