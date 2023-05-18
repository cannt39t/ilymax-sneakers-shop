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
        let profilePresenter = ProfilePresenter()
        profilePresenter.view = profileController
        profileController.presenter = profilePresenter
        
        profilePresenter.showOrdersCoordinator = goToOrdersList
        profilePresenter.showAddressesCoordinator = goToShippingAddressesList
        profilePresenter.showSalesCoordinator = goToSellingsList
        profilePresenter.showSettingsCoordinator = goToSeetings
        
        return profileController
    }
    
    private func setController(controller: UIViewController) {
        let navigationController = UINavigationController(rootViewController: controller)
        self.navigationController = navigationController
    }
    
    func startProfile() -> UIViewController {
        setController(controller: getProfileController())
        return navigationController
    }
    
    func goToSeetings(for user: IlymaxUser) {
        let settingsController = SettingsController()
        
        let settingsPresenter = SettingsPresenter(currentUser: user)
        
        settingsController.presenter = settingsPresenter
        settingsPresenter.view = settingsController
        
        navigationController.pushViewController(settingsController, animated: true)
    }
    
    func goToSellingsList(for user: IlymaxUser) {
        let salesListController = ListSalesController()
        
        let salesListPresenter = ListSalesPresenter(currentUser: user)
        salesListPresenter.pushShoes = pushShoes
        
        salesListController.presenter = salesListPresenter
        salesListPresenter.view = salesListController
        
        navigationController.pushViewController(salesListController, animated: true)
    }
    
    func goToOrdersList(for user: IlymaxUser) {
        let ordersController = OrdersCollectionViewController()
        
        let ordersPresenter = OrdersPresenter(currentUser: user)
        
        ordersPresenter.view = ordersController
        ordersController.presenter = ordersPresenter
        
        
        navigationController.pushViewController(ordersController, animated: true)
    }
    
    func goToShippingAddressesList(for user: IlymaxUser) {
        let addressesCollectionViewController = AddressesCollectionViewController()
        
        let addressesCollectionViewPresenter = AddressesPresenter(currentUser: user)
        addressesCollectionViewPresenter.pushAddAddressController = pushCreateAddressController
        
        addressesCollectionViewPresenter.view = addressesCollectionViewController
        addressesCollectionViewController.presenter = addressesCollectionViewPresenter
        
        navigationController.pushViewController(addressesCollectionViewController, animated: true)
    }
    
    func pushCreateAddressController() {
        let view = AddAddressViewController()
        let presenter = AddAddressPresenter()
        presenter.view = view
        view.presenter = presenter
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushShoes(_ shoes: Shoes) {
        let shoesViewCoordinator = ShoeViewCoordinator(navigationController: navigationController)
        shoesViewCoordinator.start(product: shoes)
    }
}
