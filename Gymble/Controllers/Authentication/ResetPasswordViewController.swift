//
//  ResetPasswordViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 28/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
class ResetPasswordViewController: UIViewController {
    fileprivate let resetPasswordTextField: UITextField = {
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
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate let proceedButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proceed", for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.backgroundColor = .systemBlue
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        cancelButtonLayout()
        textFieldLayout()
        proceedButtonLayout()
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    private func textFieldLayout(){
        view.addSubview(resetPasswordTextField)
        resetPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resetPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        resetPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        resetPasswordTextField.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 30).isActive = true
    }
    
    private func proceedButtonLayout(){
        view.addSubview(proceedButton)
        proceedButton.setGradientBackground(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
        proceedButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        proceedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        proceedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        proceedButton.topAnchor.constraint(equalTo: resetPasswordTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleReset(){
        proceedButton.showLoading()
        self.view.endEditing(true)
        guard let email = resetPasswordTextField.text else {return}
        APIServices.sharedInstance.resetPassword(email: email, onSuccess: {
            self.proceedButton.hideLoading()
            self.dismiss(animated: true, completion: nil)
        }) { (errorMessage) in
            self.proceedButton.hideLoading()
            let alert = UIAlertController(title: "Failed to send the link!", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
