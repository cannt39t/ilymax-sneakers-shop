//
//  ProfileCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class ProfileCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    private func getProfileController() -> UIViewController {
        let profileController = ProfileViewController()
        return profileController
    }
    
    private func setController(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        self.navigationController = navigationController
    }
    
    func startProfile() -> UIViewController {
        setController(controller: getProfileController())
        return navigationController
    }
    
    func goToSeetings() {
        let settingsController = UIViewController()
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func goToSellingsList() {
        let settingsController = UIViewController()
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func goToOrdersList() {
        let settingsController = UIViewController()
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func goToShippingAddressesList() {
        let settingsController = UIViewController()
        navigationController.pushViewController(settingsController, animated: true)
    }
    
}
