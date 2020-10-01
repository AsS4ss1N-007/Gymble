//
//  LoginViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    // MARK:- Properties
    fileprivate let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Hero")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let logo: UIImageView = {
        let logo = UIImageView(image: #imageLiteral(resourceName: "Gymble"))
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    fileprivate let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "LoginButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleToFill
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    fileprivate let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Forgot password?", for: .normal)
        button.addTarget(self, action: #selector(showResetPasswordVC), for: .touchUpInside)
        button.tintColor = UIColor.lightGray
        button.titleLabel?.font = UIFont(name: "Roboto-Light", size: 16)
        return button
    }()
    
    fileprivate let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 5
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string:"Email address", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        textField.setLeftPaddingPoints(15)
        textField.font = UIFont(name: "Roboto-Regular", size: 18)
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = .dark
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    fileprivate let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 5
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        textField.setLeftPaddingPoints(15)
        textField.keyboardAppearance = .dark
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: "Roboto-Regular", size: 18)
        return textField
    }()
    
    fileprivate let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        heroImageLayout()
        bottomStackLayout()
        setupSubviewsInStackView()
        loginButtonLayout()
        
    }
    
    
    // MARK:- Layouts
    
    private func resetPasswordButtonLayout(){
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: 126).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        //        forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func loginButtonLayout(){
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 2).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -2).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: -2).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func textFieldLayout(){
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: bottomStack.widthAnchor, constant: -32).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: bottomStack.widthAnchor, constant: -32).isActive = true
        
    }
    
    private func heroImageLayout(){
        view.addSubview(heroImageView)
        heroImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heroImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3, constant: -30).isActive = true
    }
    
    private func bottomStackLayout(){
        view.addSubview(bottomStack)
        bottomStack.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 2).isActive = true
        bottomStack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2).isActive = true
    }
    
    private func logoLayout(){
        logo.heightAnchor.constraint(equalToConstant: 55).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupSubviewsInStackView(){
        bottomStack.addArrangedSubview(logo)
        logoLayout()
        bottomStack.addArrangedSubview(emailTextField)
        bottomStack.addArrangedSubview(passwordTextField)
        textFieldLayout()
        resetPasswordButtonLayout()
        bottomStack.addArrangedSubview(dontHaveAccountButton)
    }
    
    // MARK:- Selectors
    
    @objc func handleLogin(){
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        let alert = UIAlertController(title: "Invalid credentials", message: "You have entered invalid details to login in. Please check and enter again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, err) in
            if let error = err{
                print(error.localizedDescription)
                if error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."{
                    self.emailTextField.shake()
                    self.present(alert, animated: true, completion: nil)
                    return
                }else if error.localizedDescription == "The password is invalid or the user does not have a password."{
                    self.passwordTextField.shake()
                    self.present(alert, animated: true, completion: nil)
                    return
                }else {
                    self.emailTextField.shake()
                    self.passwordTextField.shake()
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            guard let tabBarController = MainWindow().mainWindow?.rootViewController as? TabBarController else {return}
            tabBarController.configureTabBarController()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    @objc func handleShowSignUp(){
        let controller = SignUpViewController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func showResetPasswordVC(){
        let resetPasswordVC = ResetPasswordViewController()
        self.present(resetPasswordVC, animated: true, completion: nil)
    }
    
    
}
