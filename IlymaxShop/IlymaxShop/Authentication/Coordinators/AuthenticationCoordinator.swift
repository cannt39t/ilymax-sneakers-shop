//
//  AuthenticationCoordinator.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit

class AuthenticationCoordinator {
    
    private weak var navigationController: UINavigationController!
    
    func startLogin() -> UIViewController {
        let loginController = LoginViewController()
        let loginPresenter = LoginPresenter()
        loginController.presenter = loginPresenter
        loginPresenter.view = loginController
        loginPresenter.coordinator = self
        return loginController
    }
    
    func startSignup() -> UIViewController {
        let signUpController = SignUpViewController()
        let signUpPresenter = SignUpPresenter()
        signUpController.presenter = signUpPresenter
        signUpPresenter.view = signUpController
        signUpPresenter.coordinator = self
        return signUpController
    }
    
    func setController(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.navigationBar.isHidden = true
        self.navigationController = navigationController
    }
    
    func start() -> UIViewController {
        let controller = startSignup()
        setController(controller: controller)
        return navigationController
    }
    
    func changeToLogin() {
        let controller = startLogin()
        navigationController.viewControllers = [controller]
    }
    
    func changeToSignup() {
        let controller = startSignup()
        navigationController.viewControllers = [controller]
    }
    
    func startProfile() {
        let controller = ProfileCoordinator().start()
        navigationController.viewControllers = [controller]
    }
    
}
