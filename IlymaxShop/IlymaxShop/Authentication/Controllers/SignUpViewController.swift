//
//  SignUpViewController.swift
//  IlymaxShop
//
//  Created by Илья Казначеев on 21.03.2023.
//

import UIKit
import JGProgressHUD


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var welcomeLabel: UILabel = .init()
    private var nameTextField: UITextField = .init()
    private var emailTextField: UITextField = .init()
    private var passwordTextField: UITextField = .init()
    private var confirmPasswordTextField: UITextField = .init()
    private var signUpButton: UIButton = .init()
    private var alreadyHaveAccountLabel: UILabel = .init()
    private var signInButton: UIButton = .init()
    private let hud = JGProgressHUD()
    
    private var lastRedIndex: Int?
    var presenter: SignUpPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        setupDesign()
        setupLayout()
        
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func showLoader() {
        hud.textLabel.text = "Loading"
        hud.show(in: self.view, animated: true)
    }
    
    func hideLoader() {
        hud.dismiss(animated: true)
    }
    
    public func setupLayout(validationError: ValidationError? = nil) {
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
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }

        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        view.addSubview(frame)
        view.addSubview(mainStack)
        view.addSubview(welcomeLabel)

        NSLayoutConstraint.activate([
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
            frame.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: -40),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        frame.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    @objc private func tapedOnSignUpButton() {
        presenter.validation(nameTextField.text, emailTextField.text, passwordTextField.text, confirmPasswordTextField.text)
    }
    
    @objc private func tapedOnSignInButton() {
        presenter.switchToLoginPage()
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
    
    public func showAlert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        return true
    }
    
}
