//
//  WelcomeViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 20.03.2023.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private var welcomeImageView: UIImageView = UIImageView(image: UIImage(named: "Welcome"))
    private var loginButton: UIButton = .init()
    private var appButton: UIButton = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupDesign()
        setupLayout()
    }
    
    private func setupDesign() {
        let color = UIColor(red: 173/255.0, green: 155/255.0, blue: 124/255.0, alpha: 1.0)
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = color
        loginButton.layer.cornerRadius = 10.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(tapedOnLoginButton), for: .touchUpInside)
        
        let attributedString = NSMutableAttributedString(string: "Продолжить без регистрации")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        appButton.backgroundColor = .clear
        appButton.setAttributedTitle(attributedString, for: .normal)
        appButton.setTitleColor(.black, for: .normal)
        appButton.addTarget(self, action: #selector(tapedOnAppButton), for: .touchUpInside)
        appButton.clipsToBounds = true
    }
    
    private func setupLayout() {
        let stackTwoButtons = UIStackView(arrangedSubviews: [loginButton, appButton])
        stackTwoButtons.axis = .vertical
        stackTwoButtons.spacing = 12
        stackTwoButtons.alignment = .fill
        stackTwoButtons.distribution = .fillEqually
        
        stackTwoButtons.translatesAutoresizingMaskIntoConstraints = false
        welcomeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeImageView)
        view.addSubview(stackTwoButtons)
        
        NSLayoutConstraint.activate([
            welcomeImageView.topAnchor.constraint(equalTo: view.topAnchor),
            welcomeImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            welcomeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            welcomeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackTwoButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            stackTwoButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            stackTwoButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc public func tapedOnLoginButton() {
//        start AuthenticationCoordinator
        print("check")
    }
    
    @objc public func tapedOnAppButton() {
//        start AppCoordinator
        print("check")
    }

}
