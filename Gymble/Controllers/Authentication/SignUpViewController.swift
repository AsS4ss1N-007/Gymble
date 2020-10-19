//
//  SignUpViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var genderOptions : [String] = ["Male", "Female", "Others"]
    var userImage: UIImage? = nil
    let picker = UIPickerView()
    fileprivate let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        imageView.image = #imageLiteral(resourceName: "Bat")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "profile-edit image"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(handleUserProfileImage), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    fileprivate let firstNameTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .words
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"First name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let lastNameTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .words
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"Last name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let emailTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"Email address", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let phoneNumberTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.keyboardType = .numberPad
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"Phone number", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let genderTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"Gender", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let passwordTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.backgroundColor = .clear
        textField.isSecureTextEntry = true
        textField.keyboardAppearance = .dark
        textField.autocorrectionType = .no
        textField.setLeftPaddingPoints(15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        return textField
    }()
    
    fileprivate let repeatPasswordTextfield: UITextField = {
        let repeatTextField = UITextField()
        repeatTextField.textColor = UIColor.white
        repeatTextField.backgroundColor = .clear
        repeatTextField.isSecureTextEntry = true
        repeatTextField.keyboardAppearance = .dark
        repeatTextField.autocorrectionType = .no
        repeatTextField.setLeftPaddingPoints(15)
        repeatTextField.translatesAutoresizingMaskIntoConstraints = false
        repeatTextField.attributedPlaceholder = NSAttributedString(string:"Repeat password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font :UIFont(name: "Roboto-Regular", size: 18)!])
        repeatTextField.setLeftPaddingPoints(15)
        return repeatTextField
    }()
    
    fileprivate let textfieldStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    fileprivate let signUpButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    fileprivate let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.systemBlue]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        pickerDelegates()
        profileImageLayout()
        editButtonLayout()
        signupButtonLayout()
        stackLayout()
        textfieldsInStack()
        alreadyHaveAccountButtonLayout()
    }
    
    private func pickerDelegates(){
        picker.delegate   = self
        picker.dataSource = self
    }
    
    private func alreadyHaveAccountButtonLayout(){
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
        alreadyHaveAccountButton.widthAnchor.constraint(equalToConstant: 260).isActive = true
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func editButtonLayout(){
        view.addSubview(editButton)
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 2).isActive = true
        editButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 3).isActive = true
    }
    
    private func signupButtonLayout(){
        view.addSubview(signUpButton)
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        signUpButton.setGradientBackground(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
        
    }
    
    private func stackLayout(){
        view.addSubview(textfieldStack)
        textfieldStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
        textfieldStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textfieldStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textfieldStack.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20).isActive = true
    }
    
    private func textfieldsInStack(){
        textfieldStack.addArrangedSubview(firstNameTextfield)
        textfieldStack.addArrangedSubview(lastNameTextfield)
        textfieldStack.addArrangedSubview(emailTextfield)
        textfieldStack.addArrangedSubview(phoneNumberTextfield)
        self.genderTextfield.inputView = picker
        genderTextfield.delegate = self
        textfieldStack.addArrangedSubview(genderTextfield)
        textfieldStack.addArrangedSubview(passwordTextfield)
        textfieldStack.addArrangedSubview(repeatPasswordTextfield)
        textFieldLayout(textField: firstNameTextfield)
        firstNameTextfield.addSeperator()
        textFieldLayout(textField: lastNameTextfield)
        lastNameTextfield.addSeperator()
        textFieldLayout(textField: emailTextfield)
        emailTextfield.addSeperator()
        textFieldLayout(textField: phoneNumberTextfield)
        phoneNumberTextfield.addSeperator()
        textFieldLayout(textField: genderTextfield)
        genderTextfield.addSeperator()
        textFieldLayout(textField: passwordTextfield)
        passwordTextfield.addSeperator()
        textFieldLayout(textField: repeatPasswordTextfield)
        repeatPasswordTextfield.addSeperator()
    }
    
    private func textFieldLayout(textField: UITextField){
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.leadingAnchor.constraint(equalTo: textfieldStack.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: textfieldStack.trailingAnchor).isActive = true
        
    }
    
    private func profileImageLayout(){
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK:- CONTROLLERS
    
    @objc func handleUserProfileImage(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleShowHome(){
        let tabBarVC = TabBarController()
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    @objc func handleSignUp(){
        signUpButton.showLoading()
        guard let email = emailTextfield.text else {return}
        guard let firstName = firstNameTextfield.text else {return}
        guard let lastName = lastNameTextfield.text else {return}
        guard let phone = phoneNumberTextfield.text else {return}
        guard let gender = genderTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        guard let userProfileImage = profileImageView.image else {return}
        guard let repeatPassword = repeatPasswordTextfield.text else {return}
        
        if phoneNumberTextfield.text?.count == 10 && (gender == "Male" || gender == "Female" && gender == "Others"){
            if (password == repeatPassword && firstNameTextfield.text?.isEmpty == false && lastNameTextfield.text?.isEmpty == false && phoneNumberTextfield.text?.isEmpty == false && genderTextfield.text?.isEmpty == false && phone.count == 10){
                Auth.auth().createUser(withEmail: email, password: password) { (Authresult, err) in
                    if err == nil{
                        guard let uid = Authresult?.user.uid else {return}
                        var values = ["FirstName": firstName, "LastName": lastName, "EmailAddress": email, "PhoneNumber": "+91 \(phone)", "Gender": gender, "ProfileImage": ""]
                        guard let imageData = userProfileImage.jpegData(compressionQuality: 0.5) else {return}
                        let storageRef = Storage.storage().reference(forURL: "gs://gymble-7eb1f.appspot.com/User Profile Images")
                        let storageProfileRef = storageRef.child("User Profile Images").child(uid)
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpg"
                        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, err) in
                            if let error = err{
                                print(error.localizedDescription)
                                let alert = UIAlertController(title: "Invalid credentials", message: error.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.signUpButton.hideLoading()
                                self.present(alert, animated: true, completion: nil)
                                return
                            }
                            storageProfileRef.downloadURL { (url, err) in
                                if let metaImageURL = url?.absoluteString{
                                    values["ProfileImage"] = metaImageURL
                                    Database.database().reference().child("Users").child(uid).updateChildValues(values) { (err, ref) in
                                        if let error = err{
                                            print(error.localizedDescription)
                                            return
                                        }
                                        if #available(iOS 13.0, *) {
                                            guard let tabBarController = MainWindow().mainWindow?.rootViewController as? TabBarController else {return}
                                            tabBarController.configureTabBarController()
                                        } else {
                                            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
                                            tabBarController.configureTabBarController()
                                        }
                                        
                                        self.signUpButton.hideLoading()
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        
                    }else{
                        self.signUpButton.hideLoading()
                        let alert = UIAlertController(title: "Failed!", message: err?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                
            }
        }else{
            self.signUpButton.hideLoading()
            let alert = UIAlertController(title: "Failed!", message: "Please fill all the credentials correctly.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    }}

extension SignUpViewController{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let pickerValue: String = String(genderOptions[row])
        return pickerValue
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = String(genderOptions[row])
        self.picker.reloadAllComponents()
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImage = imageSelected
            profileImageView.image = imageSelected
            
        }
        
        if let imageSelectedOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            userImage = imageSelectedOriginal
            profileImageView.image = imageSelectedOriginal
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
