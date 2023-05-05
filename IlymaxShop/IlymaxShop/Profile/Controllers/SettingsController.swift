//
//  SettingsController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 05.05.2023.
//

import UIKit
import JGProgressHUD


class SettingsController: UIViewController {
    
    public var collectionView: UITableView!
    public var presenter: SettingsPresenter!
    private let loader = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = false
        title = "Orders"
        navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.label, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTaped))
        
        //        showLoader()
//        setupTableView()
        //        presenter.fetchSettings()
    }
    
    @objc func backButtonTaped() {
        presenter.backButtonTap()
    }
    
    func showLoader() {
        loader.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        loader.dismiss(animated: true)
    }
    
}
