//
//  HomeViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK:- Properties
    private var gymsList: [GymsList]?
    var userData: User?{
        didSet{
            guard let name = userData?.firstName else {return}
            self.titleNameView.text = "Hi \(name)"
            
            guard let image = userData?.userProfileImage else {return}
            userProfileImage.loadImageUsingUrlString(urlString: image)
        }
    }
    fileprivate let homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "Gyms")
        collectionView.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        return collectionView
    }()
    
    fileprivate lazy var titleNameView: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.textColor = UIColor.white
        label.frame = CGRect(x: 32, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        return label
    }()
    
    fileprivate let locationPin: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "LocationPin"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    fileprivate let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Light", size: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var userProfileImage: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK:- LayoutFunctions
    
    func configureUI(){
        setupNavigationBar()
        fetchGyms()
        fetchUserData()
        navigationBarButtons()
        homeCVLayout()
        setupHomeCollectionViewDelegates()
        
    }
    
    private func setupNavigationBar(){
        view.backgroundColor = .black
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.titleView = titleNameView
    }
    
    
    func navigationBarButtons(){
        let profileButton = UIButton(type: .system)
        profileButton.addSubview(userProfileImage)
        userProfileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userProfileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userProfileImage.topAnchor.constraint(equalTo: profileButton.topAnchor).isActive = true
        userProfileImage.bottomAnchor.constraint(equalTo: profileButton.bottomAnchor).isActive = true
        profileButton.setImage(userProfileImage.image, for: .normal)
        profileButton.tintColor = .white
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileButton.addTarget(self, action: #selector(showProfileVC), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        
    }
    
    func setupHomeCollectionViewDelegates(){
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
    }
    
    private func homeCVLayout(){
        view.addSubview(homeCollectionView)
        homeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        homeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        homeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        homeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    //MARK:- ControllerFunctions
    
    @objc func showProfileVC(){
        let profileVC = UserProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //MARK:- FetchAPIs
    
    func fetchGyms() {
        APIServices.sharedInstance.fetchGymsListOnHome { (gyms: [GymsList]) in
            self.gymsList = gyms
            self.homeCollectionView.reloadData()
        }
    }
    
    func fetchUserData(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        APIServices.sharedInstance.fetchUserData(uid: userID) { (userData) in
            self.userData = userData
        }
    }
}

//MARK:- Extensions

extension HomeViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = gymsList?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Gyms", for: indexPath) as! HomeCollectionViewCell
        cell.gym = gymsList?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.size.width - 32) * (9 / 16) + 80
        return CGSize(width: homeCollectionView.frame.size.width - 32, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: homeCollectionView.frame.size.width - 32, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gymDetailsVC = GymDetailsViewController()
        if let gymID = gymsList?[indexPath.item]._id{
            gymDetailsVC.gymID = gymID
        }
        self.navigationController?.pushViewController(gymDetailsVC, animated: true)
    }
}

class HeaderCell: UICollectionReusableView {
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover fitness"
        label.font = UIFont(name: "Roboto-Medium", size: 30)
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelLayout()
    }
    
    private func labelLayout(){
        addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
