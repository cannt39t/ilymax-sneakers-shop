//
//  SignUpViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var welcomeLabel: UILabel = .init()
    private var nameTextField: UITextField = .init()
    private var emailTextField: UITextField = .init()
    private var passwordTextField: UITextField = .init()
    private var confirmPasswordTextField: UITextField = .init()
    private var signUpButton: UIButton = .init()
    private var alreadyHaveAccountLabel: UILabel = .init()
    private var signInButton: UIButton = .init()
    
    private var lastRedIndex: Int?
    var presenter: SignUpPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        setupDesign()
        setupLayout()
    }
    
    private func setupLayout(validationError: ValidationError? = nil) {
        let stackSignIn = UIStackView(arrangedSubviews: [alreadyHaveAccountLabel, signInButton])
        
        var arrangedSubviews = [
            nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, stackSignIn
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
                case .mismatchedPasswords:
                    validationLabel.text = "Passwords mismatched"
                case .emailAlreadyInUse:
                    validationLabel.text = "Email already in use"
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
        mainStack.distribution = .fillProportionally

        let frame = UIView()
        frame.backgroundColor = .white

        view.addSubview(frame)
        view.addSubview(mainStack)
        view.addSubview(welcomeLabel)

        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.widthAnchor.constraint(equalTo: frame.widthAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            frame.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: -20),
            frame.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 40),
            frame.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 20),
            frame.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: -40)
        ])
        
        frame.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackSignIn.translatesAutoresizingMaskIntoConstraints = false
    }

    
    private func setupDesign() {
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = welcomeLabel.font.withSize(30)
        welcomeLabel.textAlignment = .center
        
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.accessibilityIdentifier = "name"
        
        emailTextField.placeholder = "Email"
        emailTextField.textContentType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.accessibilityIdentifier = "email"
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.accessibilityIdentifier = "password"
        
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.accessibilityIdentifier = "confirmation password"
        
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .black
        signUpButton.layer.cornerRadius = 10.0
        signUpButton.clipsToBounds = true
        signUpButton.addTarget(self, action: #selector(tapedOnSignUpButton), for: .touchUpInside)
        
        alreadyHaveAccountLabel.text = "Already have account? "
        alreadyHaveAccountLabel.textColor = .gray
        
        let attributedString = NSMutableAttributedString(string: "Sign in")
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        signInButton.backgroundColor = .clear
        signInButton.setAttributedTitle(attributedString, for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.addTarget(self, action: #selector(tapedOnSignInButton), for: .touchUpInside)
        signInButton.clipsToBounds = true
    }
    
    @objc private func tapedOnSignUpButton() throws {
        let (validationSuccess, params) = try validation()
        if validationSuccess {
            presenter.register(name: params[0], email: params[1], password: params[2])
        }
        // Start ProfileCoordinator
    }
    
    @objc private func tapedOnSignInButton() {
        presenter.switchToLoginPage()
    }
    
    private func validation() throws -> (Bool, [String]) {
        var params: [String] = []
        do {
            
            // Empty
            
            guard let textName = nameTextField.text, !textName.isEmpty else {
                throw ValidationError(atIndex: 0, type: .emptyField)
            }
            guard let textEmail = emailTextField.text, !textEmail.isEmpty else {
                throw ValidationError(atIndex: 1, type: .emptyField)
            }
            guard let textPassword = passwordTextField.text, !textPassword.isEmpty else {
                throw ValidationError(atIndex: 2, type: .emptyField)
            }
            guard let textPasswordConfirm = confirmPasswordTextField.text, !textPasswordConfirm.isEmpty else {
                throw ValidationError(atIndex: 3, type: .emptyField)
            }
            
            // Email
            
            if !ValidationError.validateEmail(email: textEmail) {
                throw ValidationError(atIndex: 1, type: .invalidEmail)
            }
            
            // Number of chars
            
            if textPassword.count < 8 {
                throw ValidationError(atIndex: 2, type: .shortPassword)
            }
            
            // Mismatched Passwords
            
            if textPassword != textPasswordConfirm {
                throw ValidationError(atIndex: 3, type: .mismatchedPasswords)
            }
            
            // Check if email available
            
            try presenter.checkAvailableEmail(email: textEmail)
            
            params.append(contentsOf: [textName, textEmail, textPassword])
        } catch let error as ValidationError {
            setupLayout(validationError: error)
            return (false, params)
        } 
        setupLayout()
        return (true, params)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !newText.isEmpty {
            welcomeLabel.text = "Welcome, \(newText)"
        } else {
            welcomeLabel.text = "Welcome"
        }
        
        return true
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
