//
//  ChangeUserNameViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 02/09/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
protocol SetNewUsername {
    func didUpdateUsername(firstName: String, lastName: String)
}

class ChangeUserNameViewController: UIViewController {
    var usernameDelegate: SetNewUsername!
    fileprivate let changeUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Change username"
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    fileprivate let firstNameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 5
        textField.autocapitalizationType = .words
        textField.setLeftPaddingPoints(15)
        textField.autocorrectionType = .no
        textField.keyboardAppearance = .dark
        textField.font = UIFont(name: "Roboto-Regular", size: 20)
        textField.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        textField.textColor = .black
        return textField
    }()
    
    fileprivate let lastNameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 5
        textField.autocapitalizationType = .words
        textField.setLeftPaddingPoints(15)
        textField.autocorrectionType = .no
        textField.keyboardAppearance = .dark
        textField.textColor = .black
        textField.font = UIFont(name: "Roboto-Regular", size: 20)
        textField.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate let submitButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleChanges), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        cancelButtonLayout()
        changeUserNameLayout()
        firstNameLayout()
        lastNameLayout()
        submitButtonLayout()
    }
    
    private func changeUserNameLayout(){
        view.addSubview(changeUserNameLabel)
        changeUserNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        changeUserNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        changeUserNameLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func firstNameLayout(){
        view.addSubview(firstNameField)
        firstNameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        firstNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firstNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstNameField.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 30).isActive = true
    }
    
    private func lastNameLayout(){
        view.addSubview(lastNameField)
        lastNameField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lastNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        lastNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        lastNameField.topAnchor.constraint(equalTo: firstNameField.bottomAnchor, constant: 20).isActive = true
    }
    
    private func submitButtonLayout(){
        view.addSubview(submitButton)
        submitButton.setGradientBackground(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: lastNameField.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChanges(){
        submitButton.showLoading()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        guard let firstName = firstNameField.text else {return}
        guard let lastName = lastNameField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if firstNameField.text?.isEmpty == true || lastNameField.text?.isEmpty == true{
            submitButton.hideLoading()
            return
        }else{
            let values: [String: Any] = [
                "FirstName": firstName,
                "LastName": lastName
            ]
            Database.database().reference().child("Users").child(uid).updateChildValues(values)
            displayChangedName(first: firstName, last: lastName)
            NotificationCenter.default.post(name: .nameOnHome, object: nil, userInfo: values) 
            submitButton.hideLoading()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func displayChangedName(first: String, last: String){
        usernameDelegate.didUpdateUsername(firstName: first, lastName: last)
        
    }
    
}
