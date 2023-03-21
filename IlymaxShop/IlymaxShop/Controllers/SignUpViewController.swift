//
//  SignUpViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit

class ValidationError: Error {
    
    public enum ValidationErrorType {
        case emptyField
        case invalidEmail
        case shortPassword
        case mismatchedPasswords
    }
    
    public var atIndex: Int
    public var type: ValidationErrorType
    
    init(atIndex: Int, type: ValidationErrorType) {
        self.atIndex = atIndex
        self.type = type
    }
    
    public static func validateEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}


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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        setupDesign()
        setupLayout()
    }
    
    private func setupLayout(validationError: ValidationError? = nil) {
        let stackSignIn = UIStackView(arrangedSubviews: [alreadyHaveAccountLabel, signInButton])
        stackSignIn.distribution = .equalCentering
        stackSignIn.alignment = .center
        
        var arrangedSubviews = [
            nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, stackSignIn
        ]
        
        if let index = lastRedIndex {
            resetTextFieldAppearance(arrangedSubviews[index] as! UITextField)
        }
        
        if let error = validationError {
            let validationLabel: UILabel = .init()
            validationLabel.textColor = .red
            switch error.type {
                case .emptyField:
                    validationLabel.text = "Field can't be blank"
                case .invalidEmail:
                    validationLabel.text = "Invalid email"
                case .shortPassword:
                    validationLabel.text = "Password must contains at least 8 characters"
                case .mismatchedPasswords:
                    validationLabel.text = "Passwords mismatched"
                }
            highlightTextField(arrangedSubviews[error.atIndex] as! UITextField)
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
            mainStack.topAnchor.constraint(equalTo: frame.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: frame.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: frame.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: frame.bottomAnchor, constant: -12),

            frame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            frame.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            frame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            frame.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.widthAnchor.constraint(equalTo: frame.widthAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
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
        
        emailTextField.placeholder = "Email"
        emailTextField.textContentType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        
        confirmPasswordTextField.placeholder = "Confirm password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        
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
        let flag = try validation()
        // Create user in service
        // Add user to session
        // Start ProfileCoordinator
    }
    
    @objc private func tapedOnSignInButton() {
        print("Переход на авторизацию")
    }
    
    private func validation() throws -> Bool {
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
            
        } catch let error as ValidationError {
            setupLayout(validationError: error)
            return false
        }
        setupLayout()
        return true
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
