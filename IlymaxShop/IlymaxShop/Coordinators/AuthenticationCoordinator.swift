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
        controller.navigationItem.setHidesBackButton(true, animated: false)
        setController(controller: controller)
        return navigationController
    }
    
    func changeToLogin() {
        navigationController.popViewController(animated: false)
        navigationController.pushViewController(startLogin(), animated: false)
    }
    
    func changeToSignup() {
        navigationController.popViewController(animated: false)
        navigationController.pushViewController(startSignup(), animated: false)
    }
    
//    func changeToLogin() {
//        let controller = startLogin()
//        setController(controller: controller)
//    }
    
}
