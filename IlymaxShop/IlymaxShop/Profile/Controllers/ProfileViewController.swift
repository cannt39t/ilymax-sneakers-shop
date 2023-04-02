//
//  ProfileViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var label: UILabel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDesign()
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(label)
    
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupDesign() {
        label.text = "Hello, \(FirebaseAuthenticationService.user?.email!)"
    }

}
