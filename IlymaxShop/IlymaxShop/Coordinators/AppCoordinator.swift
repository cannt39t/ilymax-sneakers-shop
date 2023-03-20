//
//  AppCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class AppCoordinator {
    
    func start() -> UIViewController {
        /*
         if first time app launch
            show welcome controller
         else
            start tabbar controller
        */
        
//        let welcomeViewController = WelcomeViewController()
//        return welcomeViewController
        
        let tabbarCoordinator = TabBarCoordinator()
        return tabbarCoordinator.start()
    }
    
}
