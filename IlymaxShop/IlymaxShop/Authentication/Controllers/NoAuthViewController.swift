//
//  NoAuthViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 30.03.2023.
//

import UIKit

class NoAuthViewController: UIViewController {
    
    private let sneakersImage: UIImageView = .init(image: UIImage(named: "sneakers")?.withTintColor(.label, renderingMode: .alwaysOriginal))
    private var textLabel: UILabel = .init()
    private var authButton: UIButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDesign()
        setupLayout()
    }
    
    
    private func setupDesign() {
        view.backgroundColor = .systemGroupedBackground
        
        textLabel.text = "You are not authorized to use this function"
        textLabel.font = textLabel.font.withSize(20)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        
        authButton.setTitle("Log in", for: .normal)
        authButton.titleLabel?.font = textLabel.font.withSize(20)
        authButton.setTitleColor(.systemBackground, for: .normal)
        authButton.backgroundColor = .label
        authButton.layer.cornerRadius = 10.0
        authButton.clipsToBounds = true
        authButton.addTarget(self, action: #selector(tapedOnAuthButton), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews:  [textLabel, authButton])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        stack.distribution = .equalCentering
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        sneakersImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sneakersImage)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            sneakersImage.widthAnchor.constraint(equalToConstant: 300),
            sneakersImage.heightAnchor.constraint(equalToConstant: 300),
            sneakersImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sneakersImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            stack.topAnchor.constraint(equalTo: sneakersImage.bottomAnchor, constant: -60),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            authButton.heightAnchor.constraint(equalToConstant: 48),
            authButton.widthAnchor.constraint(equalToConstant: 128)
        ])
    }
    
    @objc private func tapedOnAuthButton() {
        tabBarController?.selectedIndex = 4
    }

}
