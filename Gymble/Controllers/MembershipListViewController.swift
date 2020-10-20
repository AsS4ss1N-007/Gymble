//
//  MembershipListViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 01/10/20.
//

import UIKit
import Razorpay
import Firebase
import Alamofire
import FirebaseAuth
class MembershipListViewController: UIViewController, RazorpayProtocol{
    weak var razorpay: RazorpayCheckout?
    let rightNow = Date()
    var gymID: String = ""
    var userData: User?
    var userID: String?
    var selectedPrice: String?
    var selectedPlan: Int?
    var getMembership: GymMembershipPrices? {
        didSet{
            guard let gymName = getMembership?.gym_name else {return}
            self.gymNameLabel.text = gymName
            
            rateCV.reloadData()
        }
    }
    fileprivate let gymNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let seperator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let rateCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MembershipListsCell.self, forCellWithReuseIdentifier: "Price")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    fileprivate let buyMembershipButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.setTitle("Buy Now", for: .normal)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(buyMembership), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyMembershipButton.setGradientBackgroundOnBuyButtom(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
        fetchUserData()
        razorpay = RazorpayCheckout.initWithKey("rzp_live_KuZC0TeE61lTmT", andDelegate: self)
        getMembershipPrices()
        view.backgroundColor = .black
        setupNavigationBar()
        gymNameLabelLayout()
        seperatorLayout()
        buyButtonLayout()
        rateCVLayout()
        setupCVDelegates()
    }
    
    func fetchUserData(){
        guard let userid = Auth.auth().currentUser?.uid else {return}
        userID = userid
        APIServices.sharedInstance.fetchUserData(uid: userid) { (getUserInfo) in
            self.userData = getUserInfo
        }
    }
    
    func setupCVDelegates(){
        rateCV.delegate = self
        rateCV.dataSource = self
    }
    
    private func buyButtonLayout(){
        view.addSubview(buyMembershipButton)
        buyMembershipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buyMembershipButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        buyMembershipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        buyMembershipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func rateCVLayout(){
        view.addSubview(rateCV)
        rateCV.topAnchor.constraint(equalTo: seperator.bottomAnchor).isActive = true
        rateCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        rateCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        rateCV.bottomAnchor.constraint(equalTo: buyMembershipButton.topAnchor, constant: -20).isActive = true
    }
    
    private func seperatorLayout(){
        view.addSubview(seperator)
        seperator.topAnchor.constraint(equalTo: gymNameLabel.bottomAnchor, constant: 5).isActive = true
        seperator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        seperator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    private func gymNameLabelLayout(){
        view.addSubview(gymNameLabel)
        gymNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        gymNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        gymNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    
    private func setupNavigationBar(){
        self.navigationItem.title = "Memberships"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc func buyMembership(){
        buyMembershipButton.showLoading()
        guard let phone = userData?.phoneNumber else {
            buyMembershipButton.hideLoading()
            return
        }
        guard let email = userData?.email else {
            buyMembershipButton.hideLoading()
            return
        }
        
        guard let membershipPrice = selectedPrice else {
            buyMembershipButton.hideLoading()
            return
        }
        guard let gymName = getMembership?.gym_name else {return}
        let options: [String:Any] = [
            "amount" : "\(membershipPrice)00", //mandatory in paise like:- 1000 paise ==  10 rs
            "description": "Welcome to the \(gymName)",
            "image": UIImage(named: "Gymble")!,
            "name": "Gymble",
            "prefill": [
                "contact": phone,
                "email": email
            ],
            "theme": [
                "color": "#F2380F"
            ]
        ]
        razorpay?.open(options)
        buyMembershipButton.hideLoading()
    }
    
    private func getMembershipPrices(){
        APIServices.sharedInstance.getGymMembershipPrices(gymID: gymID) { (getMembershipData) in
            self.getMembership = getMembershipData
        }
    }
}

extension MembershipListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = getMembership?.subscriptions.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Price", for: indexPath) as! MembershipListsCell
        let membershipArray = ["Monthly", "Quarterly", "Half-Yearly", "Annually"]
        cell.timeLabel.text = membershipArray[indexPath.item]
        if let duration = getMembership?.subscriptions[indexPath.item].duration{
            if duration == 1{
                cell.perMonthLabel.text = "/" + "\(duration) month"
            }else {
                cell.perMonthLabel.text = "/" + "\(duration) months"
            }
        }
        if let price = getMembership?.subscriptions[indexPath.item].price{
            cell.rateLabel.text = price
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: rateCV.frame.size.width - 8, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MembershipListsCell
        guard let price = cell?.rateLabel.text else {return}
        selectedPrice = price
        
        if indexPath.item == 0{
            selectedPlan = (1 * 30)
        }
        else if indexPath.item == 1{
            selectedPlan = (3 * 30)
        }
        else if indexPath.item == 2{
            selectedPlan = (6 * 30)
        }
        else if indexPath.item == 3{
            selectedPlan = (12 * 30)
        }else{
            selectedPlan = 0
        }
    }
}

extension MembershipListViewController: RazorpayPaymentCompletionProtocol{
    func onPaymentError(_ code: Int32, description str: String) {
        let alert = UIAlertController(title: "Payment failed", message: "Error code: \(code) \(str)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alert = UIAlertController(title: "Success", message: "Payment Successful", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        let url = "http://13.233.119.231:3000/newSubscription"
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let gymName = getMembership?.gym_name else {return}
        guard let firstName = userData?.firstName else {return}
        guard let lastName = userData?.lastName else {return}
        guard let phoneNumber = userData?.phoneNumber else {return}
        guard let plan = selectedPlan  else {return}
        guard let email = userData?.email else {return}
        let modifiedDate = Calendar.current.date(byAdding: .day, value: plan, to: rightNow)!
        let parameters: [String : Any] = [
            "user_id": uid,
            "customer_name": "\(firstName) \(lastName)",
            "phone_no": phoneNumber,
            "email": email,
            "gym_id": gymID,
            "gym_name": gymName,
            "start_date": rightNow.convertToString(),
            "end_date": modifiedDate.convertToString(),
            "is_active": "true",
        ]
        print(parameters)
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
//            print("DEBUG: \(response.response?.statusCode)")
            switch (response.result) {
            case .success:
                print(response)
                break
            case .failure:
                print(Error.self)
            }
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}


