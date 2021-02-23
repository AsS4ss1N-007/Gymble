//
//  UserProfileViewController.swift
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
import FirebaseFirestore
protocol SetUserProfileImageOnHome {
    func setUserProfile(image: UIImage)
}
protocol SetUserNameOnHome {
    func setUserNameOnHome(firstName: String)
}
class UserProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SetNewUsername{
    var setUserNameOnHomeDelegate: SetUserNameOnHome!
    var setUserProfileImageOnHomeDelegate: SetUserProfileImageOnHome!
    var userDetails: User?{
        didSet{
            guard let userProfile = userDetails?.userProfileImage else {return}
            guard let userFirstName = userDetails?.firstName else {return}
            guard let userLastName = userDetails?.lastName else {return}
            self.nameLabel.text = "\(userFirstName) \(userLastName)"
            self.userProfileImage.loadImageUsingUrlString(urlString: userProfile)
            detailsCV.reloadData()
        }
    }
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.textColor = .white
        return label
    }()
    
    fileprivate let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "profile-edit image"), for: .normal)
        return button
    }()
    
    fileprivate lazy var userProfileImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.layer.cornerRadius = 60
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFullScreenUserImage)))
        return image
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Medium", size: 25)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate let detailsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        let detailsCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        detailsCV.translatesAutoresizingMaskIntoConstraints = false
        detailsCV.register(UserProfileDetailsCell.self, forCellWithReuseIdentifier: "Details")
        detailsCV.backgroundColor = .black
        return detailsCV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI(){
        fetchUserData()
        view.backgroundColor = UIColor.black
        setupNavigationBar()
        signOutButton()
        profileImageLayout()
        editButtonLayout()
        nameLabelLayout()
        detailsCVLayout()
        setupDelagates()
    }
    
    @objc func showFullScreenUserImage(){
        let fullScreenImageVC = FullScreenUserProfileImage()
        fullScreenImageVC.userImage = userProfileImage.image
        self.present(fullScreenImageVC, animated: true, completion: nil)
    }
    
    func updateProfileImage(image: UIImage){
        setUserProfileImageOnHomeDelegate.setUserProfile(image: image)
    }
    
    func didUpdateUsername(firstName: String, lastName: String) {
        setUserNameOnHomeDelegate.setUserNameOnHome(firstName: firstName)
        nameLabel.text = "\(firstName) \(lastName)"
    }
    
    private func setupDelagates(){
        detailsCV.delegate = self
        detailsCV.dataSource = self
    }
    
    private func detailsCVLayout(){
        view.addSubview(detailsCV)
        detailsCV.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        detailsCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailsCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        detailsCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    private func nameLabelLayout(){
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 30).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    private func editButtonLayout(){
        view.addSubview(editButton)
        editButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        editButton.bottomAnchor.constraint(equalTo: userProfileImage.bottomAnchor).isActive = true
        editButton.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor).isActive = true
    }
    
    private func profileImageLayout(){
        view.addSubview(userProfileImage)
        userProfileImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        userProfileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    fileprivate func setupNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = titleLabel
        navigationItem.backBarButtonItem?.title = "Home"
        
    }
    
    fileprivate func signOutButton(){
        let signOut = UIButton(type: .system)
        signOut.setTitle("Logout", for: .normal)
        signOut.translatesAutoresizingMaskIntoConstraints = false
        signOut.tintColor = Colors.mainOrange
        signOut.clipsToBounds = true
        signOut.layer.cornerRadius = 10
        signOut.layer.borderColor = Colors.mainOrange.cgColor
        signOut.layer.borderWidth = 0.5
        signOut.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        signOut.backgroundColor = .clear
        signOut.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        signOut.translatesAutoresizingMaskIntoConstraints = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOut)
        signOut.heightAnchor.constraint(equalToConstant: 44).isActive = true
        signOut.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    @objc func handleLogout(){
        let alert = UIAlertController(title: "Log Out", message: "Are you sure that you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (signUserOut) in
            self.signOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (dismiss) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true) {
                self.presentLoginController()
            }
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigationBar.isHidden = true
            nav.navigationItem.hidesBackButton = true
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func fetchUserData(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        APIServices.sharedInstance.fetchUserData(uid: uid) { (userData) in
            self.userDetails = userData
        }
    }
    
    @objc func handleChangePhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension UserProfileViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Details", for: indexPath) as! UserProfileDetailsCell
        cell.editButton.isHidden = true
        if indexPath.item == 0{
            cell.editButton.isHidden = false
            cell.cellLabel.text = "Change username"
        }
        if indexPath.item == 1{
            if let email = userDetails?.email{
                cell.cellLabel.text = email
            }
        }
        if indexPath.item == 2{
            cell.editButton.isHidden = false
            cell.cellLabel.text = "Change phone number"
        }
        if indexPath.item == 3{
            cell.cellLabel.text = "About GYMBLE"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: detailsCV.frame.size.width - 32, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0{
            let changeUserNameVC = ChangeUserNameViewController()
            changeUserNameVC.usernameDelegate = self
            self.present(changeUserNameVC, animated: true, completion: nil)
        }
        
        if indexPath.item == 2{
            let changeUserNameVC = ChangePhoneViewController()
            self.present(changeUserNameVC, animated: true, completion: nil)
        }
        if indexPath.item == 3{
            if let url = URL(string: "http://gymble.in") {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        userProfileImage.image = imageSelected
        updateProfileImage(image: imageSelected)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        let storageRef = Storage.storage().reference(forURL: "gs://gymble-7eb1f.appspot.com")
        let storageProfileRef = storageRef.child("User Profile Images").child(uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metadata) { (storageMetadata, err) in
            if let error = err{
                print(error.localizedDescription)
                return}
            storageProfileRef.downloadURL { (url, err) in
                if let metaImageURL = url?.absoluteString{
                    let values = ["ProfileImage": metaImageURL]
                    Firestore.firestore().collection("Users").document(uid).updateData(values) { (err) in
                        if let error = err{
                            print(error.localizedDescription)
                            return
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

class FullScreenUserProfileImage: UIViewController {
    var userImage: UIImage?
    fileprivate let imageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 13
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButtonLayout()
        view.bringSubviewToFront(cancelButton)
        view.backgroundColor = Colors.mainBlack
        imageViewLayout()
        guard let userPic = userImage else {return}
        imageView.image = userPic
        
    }
    
    private func imageViewLayout(){
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true, completion: nil)
    }
}
