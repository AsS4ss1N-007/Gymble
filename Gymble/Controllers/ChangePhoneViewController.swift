//
//  ChangePhoneViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 02/09/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
class ChangePhoneViewController: UIViewController {
    var userPhone: User?{
        didSet{
            guard let phone = userPhone?.phoneNumber else {return}
            self.changeUserPhoneLabel.text = phone
        }
    }
    fileprivate let changeUserPhoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    fileprivate let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Phone number"
        textField.layer.cornerRadius = 5
        textField.keyboardType = .numberPad
        textField.setLeftPaddingPoints(15)
        textField.autocorrectionType = .no
        textField.keyboardAppearance = .dark
        textField.font = UIFont(name: "Roboto-Regular", size: 20)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string:"Phone number", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
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
        fetchUserEmail()
        cancelButtonLayout()
        changeUserPhoneLayout()
        phoneLayout()
        submitButtonLayout()
    }
    
    private func fetchUserEmail(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        APIServices.sharedInstance.fetchUserData(uid: uid) { (userPhone) in
            self.userPhone = userPhone
        }
    }
    
    private func changeUserPhoneLayout(){
        view.addSubview(changeUserPhoneLabel)
        changeUserPhoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        changeUserPhoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        changeUserPhoneLabel.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func phoneLayout(){
        view.addSubview(phoneTextField)
        phoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 30).isActive = true
    }
    
    private func submitButtonLayout(){
        view.addSubview(submitButton)
        submitButton.setGradientBackground(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        submitButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20).isActive = true
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChanges(){
        guard let phone = phoneTextField.text else {return}
        if phone.count == 10{
            submitButton.showLoading()
            phoneTextField.resignFirstResponder()
            guard let phone = phoneTextField.text else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let value: [String: Any] = ["PhoneNumber": phone]
            Database.database().reference().child("Users").child(uid).updateChildValues(value)
            dismiss(animated: true, completion: nil)
        }else{
            phoneTextField.attributedPlaceholder = NSAttributedString(string:"Invalid phone number", attributes:[NSAttributedString.Key.foregroundColor: UIColor.systemRed, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
            return
        }
    }
    
    
}
