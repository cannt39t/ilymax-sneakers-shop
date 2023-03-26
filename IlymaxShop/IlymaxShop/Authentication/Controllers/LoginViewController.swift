//
//  LoginViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var welcomeLabel: UILabel = .init()
    private var emailTextField: UITextField = .init()
    private var passwordTextField: UITextField = .init()
    private var loginButton: UIButton = .init()
    private var dontHaveAccountLabel: UILabel = .init()
    private var signUpButton: UIButton = .init()
    
    private var lastRedIndex: Int?
    var presenter: LoginPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDesign()
        setupLayout()
    }
    
    private func setupLayout(validationError: ValidationError? = nil) {
        let stackSignIn = UIStackView(arrangedSubviews: [dontHaveAccountLabel, signUpButton])
        
        var arrangedSubviews = [
           emailTextField, passwordTextField, loginButton, stackSignIn
        ]
        
        if let index = lastRedIndex {
            resetTextFieldAppearance(arrangedSubviews[index] as! UITextField)
        }
        
        if let error = validationError {
            let validationLabel: UILabel = .init()
            validationLabel.textColor = .red
            validationLabel.font = validationLabel.font.withSize(15)
            let problemTextField = (arrangedSubviews[error.atIndex] as! UITextField)
            switch error.type {
                case .emptyField:
                    validationLabel.text = "Please enter \(String(describing: problemTextField.accessibilityIdentifier!))"
                case .invalidEmail:
                    validationLabel.text = "Email doesn't exist"
                case .shortPassword:
                    validationLabel.text = "Password is too short"
                case .cannotFindEmail:
                    validationLabel.text = "Email not found"
                case .invalidPassword:
                    validationLabel.text = "The password is incorrect"
                default:
                    validationLabel.text = "Error"
            }
            highlightTextField(problemTextField)
            lastRedIndex = error.atIndex
            arrangedSubviews.insert(validationLabel, at: error.atIndex)
        }
        
        let mainStack = UIStackView(arrangedSubviews: arrangedSubviews)
        
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually

        let frame = UIView()
        frame.backgroundColor = .white
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        view.addSubview(frame)
        view.addSubview(mainStack)
        view.addSubview(welcomeLabel)

        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.widthAnchor.constraint(equalTo: frame.widthAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: frame.topAnchor, constant: -24),
            
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            frame.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: -20),
            frame.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 10),
            frame.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 20),
            frame.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: -40)
        ])
        
        frame.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackSignIn.translatesAutoresizingMaskIntoConstraints = false
    }

    
    private func setupDesign() {
        welcomeLabel.text = "Welcome back"
        welcomeLabel.font = welcomeLabel.font.withSize(30)
        welcomeLabel.textAlignment = .center
        
        emailTextField.placeholder = "Email"
        emailTextField.textContentType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.accessibilityIdentifier = "email"
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.accessibilityIdentifier = "password"
        
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .black
        loginButton.layer.cornerRadius = 10.0
        loginButton.clipsToBounds = true
        loginButton.addTarget(self, action: #selector(tapedOnLoginButton), for: .touchUpInside)
        
        dontHaveAccountLabel.text = "Don't have an account yet?"
        dontHaveAccountLabel.textColor = .gray
        
        let attributedString = NSMutableAttributedString(string: "Sign up")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        signUpButton.backgroundColor = .clear
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(tapedOnSignUpButton), for: .touchUpInside)
        signUpButton.clipsToBounds = true
    }
    
    @objc private func tapedOnLoginButton() throws {
        let (validationSuccess, params) = try validation()
        if validationSuccess {
            presenter.login(email: params[0])
        }
        // Start ProfileCoordinator
    }
    
    @objc private func tapedOnSignUpButton() {
        presenter.switchToSignUpPage()
    }
    
    private func validation() throws -> (Bool, [String]) {
        var params: [String] = []
        do {
            
            // Empty
            
            guard let textEmail = emailTextField.text, !textEmail.isEmpty else {
                throw ValidationError(atIndex: 0, type: .emptyField)
            }
            guard let textPassword = passwordTextField.text, !textPassword.isEmpty else {
                throw ValidationError(atIndex: 1, type: .emptyField)
            }
            
            // Email
            
            if !ValidationError.validateEmail(email: textEmail) {
                throw ValidationError(atIndex: 0, type: .invalidEmail)
            }
            
            // Number of chars
            
            if textPassword.count < 8 {
                throw ValidationError(atIndex: 1, type: .shortPassword)
            }
            
            // Check if email exist in database
            
            try presenter.emailExists(email: textEmail)
            
            // Check if password is correct
            
            try presenter.validPassword(email: textEmail, password: textPassword)
            
            params.append(contentsOf: [textEmail, textPassword])
        } catch let error as ValidationError {
            setupLayout(validationError: error)
            return (false, params)
        }
        setupLayout()
        return (true, params)
        
    }
    
    private func highlightTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.cornerRadius = 5.0
    }
    
    private func resetTextFieldAppearance(_ textField: UITextField) {
        textField.layer.borderWidth = 0.0
        textField.layer.borderColor = nil
        textField.layer.cornerRadius = 0.0
    }
    
}
