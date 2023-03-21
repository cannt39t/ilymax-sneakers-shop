//
//  SignInCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit

class SignInCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    func start() -> UIViewController {
        let signUpController = SignUpViewController()
        let navigationController = UINavigationController(rootViewController: signUpController)
        self.navigationController = navigationController
        return navigationController
    }
    
}
