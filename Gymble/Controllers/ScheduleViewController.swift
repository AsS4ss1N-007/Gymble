//
//  ScheduleViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import Alamofire
import FirebaseAuth
import AVFoundation
class ScheduleViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    let rightNow = Date()
    let calendar = Calendar.current
    var slotID: String?
    var slotTime: String?
    var slotDate: String? = Date().asString()
    var userFullName: String?
    var userPhoneNumber: String?
    let uid = Auth.auth().currentUser?.uid
    let activityView = UIActivityIndicatorView()
    var checkForBooking: CheckForbooking?{
        didSet{
            if checkForBooking?.is_active == false{
                noSubscription.imageView.image = #imageLiteral(resourceName: "Error")
                noSubscriptionContainerLayout()
                
            }
            else if(checkForBooking?.booked == true && checkForBooking?.is_active == true && checkForBooking?.already_booked?.check_in_status == true){
                noSubscription.imageView.image = #imageLiteral(resourceName: "Relax")
                noSubscriptionContainerLayout()
            }
            else if (checkForBooking?.booked == true && checkForBooking?.is_active == true) {
                noSubscriptionContainer.removeFromSuperview()
                if let gymName = checkForBooking?.already_booked?.gym_name {
                    gymNameOnTicket.text = gymName
                }
                
                if let timeOnSlot = checkForBooking?.already_booked?.time{
                    slotTimeLabel.text = timeOnSlot
                }
                guard let uid = Auth.auth().currentUser?.uid else {return}
                APIServices.sharedInstance.fetchUserData(uid: uid) { (userName) in
                    guard let firstName = userName.firstName else {return}
                    guard let lastName = userName.lastName else {return}
                    guard let imageURL = userName.userProfileImage else {return}
                    self.userName.text = "\(firstName) \(lastName)"
                    self.userImage.loadImageUsingUrlString(urlString: imageURL)
                }
                addslotBookingDetailsContainerToView()
                
            }else if(checkForBooking?.booked == false && checkForBooking?.is_active == true){
                backgroundForBookingDetailsCard.removeFromSuperview()
                bookedSlotDetailsContainer.removeFromSuperview()
                noSubscriptionContainer.removeFromSuperview()
            }
        }
        
    }
    
    var showSlotsData: ShowSlotBookingSlots?{
        didSet{
            if showSlotsData?.is_active == true && showSlotsData?.booked == false{
                guard let gymName = showSlotsData?.slots?.gym_name else {return}
                self.gymNameLabel.text = gymName
                guard let remainingDays = showSlotsData?.days_left else {return}
                if remainingDays == 1 || remainingDays == 0{
                    self.daysLeftLabel.text = "\(remainingDays) day left"
                }else{
                    self.daysLeftLabel.text = "\(remainingDays) days left"
                }
                self.slotsCollectionView.reloadData()
            }
            
        }
    }
    
    fileprivate lazy var buttonActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = Colors.mainOrange
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            indicator.style = .medium
        } else {
            indicator.style = .gray
        }
        return indicator
    }()
    
    fileprivate let gymNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 22)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let daysLeftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 20)
        label.textAlignment = .right
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    fileprivate let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemPurple
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    fileprivate let calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemPurple
        collectionView.layer.cornerRadius = 16
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 16)
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "Calendar")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let slotsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SlotsCell.self, forCellWithReuseIdentifier: "Slots")
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    fileprivate let sliderLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return line
    }()
    
    fileprivate let bookButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleBooking), for: .touchUpInside)
        button.layer.masksToBounds = true
        return button
    }()
    
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Light", size: 20)
        button.tintColor = UIColor.white.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(cancelSlotSelection), for: .touchUpInside)
        return button
    }()
    
    fileprivate let noSubscriptionContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.black
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    fileprivate let noSubscription: NoMembershipView = {
        let image = NoMembershipView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    fileprivate let backgroundForBookingDetailsCard: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.black
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    fileprivate let bookedSlotDetailsContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.black
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    fileprivate let slotsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Available Slots"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()
    
    fileprivate let bookingTicket: BookingTicket = {
        let ticket = BookingTicket()
        ticket.translatesAutoresizingMaskIntoConstraints = false
        return ticket
    }()
    
    fileprivate let userImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate let gymNameOnTicket: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 17)
        label.textAlignment = .right
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 16)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let slot: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 16)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.text = "Slot"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let slotTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textAlignment = .left
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let checkInButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check-In", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 20)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(showScannerVC), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.backgroundColor  = .systemRed
        return button
    }()
    
    fileprivate let slotCancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel slot?", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Light", size: 16)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleSlotCancelling), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.backgroundColor  = .clear
        return button
    }()
    
    fileprivate let buttonStck: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.center = view.center
        activityView.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityView.style = .large
        } else {
            activityView.style = .gray
        }
        activityView.backgroundColor = Colors.mainBlack
        activityView.assignColor(Colors.mainOrange)
        getUserFullName()
        chekcSlotBooking()
        setupNavigationBar()
        topViewLayout()
        collectionViewDelegates()
        calendarCollectionViewLayout()
        calendarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
        gymNameLabelLayout()
        daysLeftLabelLayout()
        slotsLabelLayout()
        sliderLineLayout()
        cancelButtonLayout()
        bookButtonLayout()
        slotsCollectionViewLayout()
        showSlotDetails()
    }
    
    private func slotsLabelLayout(){
        view.addSubview(slotsLabel)
        slotsLabel.topAnchor.constraint(equalTo: gymNameLabel.bottomAnchor, constant: 15).isActive = true
        slotsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        slotsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
    }
    
    private func addslotBookingDetailsContainerToView(){
        backgroundForBookingDetailsCardLayout()
        bookedSlotDetailsContainerLayout()
        ticketLayout()
        userImageLayout()
        gymNameTicketLayout()
        nameLayout()
        userNameLayout()
        slotLayout()
        slotTimeLayout()
        buttonStackLayout()
        buttonStackSubViews()
    }
    
    private func ticketLayout(){
        bookedSlotDetailsContainer.addSubview(bookingTicket)
        bookingTicket.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bookingTicket.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bookingTicket.centerYAnchor.constraint(equalTo: bookedSlotDetailsContainer.centerYAnchor, constant: -50).isActive = true
        bookingTicket.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }
    
    private func userImageLayout(){
        bookedSlotDetailsContainer.addSubview(userImage)
        userImage.topAnchor.constraint(equalTo: bookingTicket.topAnchor, constant: 10).isActive = true
        userImage.leadingAnchor.constraint(equalTo: bookingTicket.leadingAnchor, constant: 21).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func gymNameTicketLayout(){
        bookedSlotDetailsContainer.addSubview(gymNameOnTicket)
        gymNameOnTicket.trailingAnchor.constraint(equalTo: bookingTicket.trailingAnchor, constant: -view.frame.size.width/2 - 5).isActive = true
        gymNameOnTicket.topAnchor.constraint(equalTo: userImage.topAnchor).isActive = true
        gymNameOnTicket.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 5).isActive = true
    }
    
    private func nameLayout(){
        bookedSlotDetailsContainer.addSubview(name)
        name.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 20).isActive = true
        name.trailingAnchor.constraint(equalTo: gymNameOnTicket.trailingAnchor, constant: -5).isActive = true
        name.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10).isActive = true
    }
    
    private func userNameLayout(){
        bookedSlotDetailsContainer.addSubview(userName)
        userName.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 20).isActive = true
        userName.trailingAnchor.constraint(equalTo: gymNameOnTicket.trailingAnchor, constant: -5).isActive = true
        userName.topAnchor.constraint(equalTo: name.bottomAnchor).isActive = true
    }
    
    private func slotLayout(){
        bookedSlotDetailsContainer.addSubview(slot)
        slot.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 20).isActive = true
        slot.trailingAnchor.constraint(equalTo: gymNameOnTicket.trailingAnchor, constant: -5).isActive = true
        slot.topAnchor.constraint(equalTo: userName.bottomAnchor).isActive = true
    }
    
    private func slotTimeLayout(){
        bookedSlotDetailsContainer.addSubview(slotTimeLabel)
        slotTimeLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 20).isActive = true
        slotTimeLabel.trailingAnchor.constraint(equalTo: gymNameOnTicket.trailingAnchor, constant: -5).isActive = true
        slotTimeLabel.topAnchor.constraint(equalTo: slot.bottomAnchor).isActive = true
    }
    
    private func buttonStackLayout(){
        bookedSlotDetailsContainer.addSubview(buttonStck)
        buttonStck.topAnchor.constraint(equalTo: gymNameOnTicket.bottomAnchor, constant: 20).isActive = true
        buttonStck.trailingAnchor.constraint(equalTo: bookingTicket.trailingAnchor, constant: -16).isActive = true
        buttonStck.leadingAnchor.constraint(equalTo: bookingTicket.centerXAnchor).isActive = true
        buttonStck.bottomAnchor.constraint(equalTo: slot.bottomAnchor, constant: 5).isActive = true
    }
    
    private func buttonStackSubViews(){
        buttonStck.addArrangedSubview(checkInButton)
        checkInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        checkInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonStck.addArrangedSubview(slotCancelButton)
        slotCancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        slotCancelButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func backgroundForBookingDetailsCardLayout(){
        view.addSubview(backgroundForBookingDetailsCard)
        backgroundForBookingDetailsCard.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        backgroundForBookingDetailsCard.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundForBookingDetailsCard.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundForBookingDetailsCard.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    private func bookedSlotDetailsContainerLayout(){
        view.addSubview(bookedSlotDetailsContainer)
        bookedSlotDetailsContainer.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        bookedSlotDetailsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        bookedSlotDetailsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        bookedSlotDetailsContainer.heightAnchor.constraint(equalToConstant: 340).isActive = true
    }
    
    private func noSubsLayout(){
        noSubscriptionContainer.addSubview(noSubscription)
        noSubscription.widthAnchor.constraint(equalTo: noSubscriptionContainer.widthAnchor, constant: -40).isActive = true
        noSubscription.heightAnchor.constraint(equalTo: noSubscription.widthAnchor).isActive = true
        noSubscription.centerXAnchor.constraint(equalTo: noSubscriptionContainer.centerXAnchor).isActive = true
        noSubscription.centerYAnchor.constraint(equalTo: noSubscriptionContainer.centerYAnchor).isActive = true
    }
    
    private func noSubscriptionContainerLayout(){
        view.addSubview(noSubscriptionContainer)
        noSubscriptionContainer.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        noSubscriptionContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        noSubscriptionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noSubscriptionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noSubsLayout()
    }
    
    func tomorrow(value: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.setValue(value, for: .day) // +1 day
        let tomorrow = Calendar.current.date(byAdding: dateComponents, to: rightNow)  // Add the DateComponents
        return tomorrow!
    }
    
    private func cancelButtonLayout(){
        view.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func bookButtonLayout(){
        view.addSubview(bookButton)
        bookButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        bookButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        bookButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        bookButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20).isActive = true
        bookButton.setGradientBackground(colorOne: Colors.mainRed, colorTwo: Colors.mainOrange)
    }
    
    private func sliderLineLayout(){
        view.addSubview(sliderLine)
        sliderLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sliderLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sliderLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        sliderLine.topAnchor.constraint(equalTo: slotsLabel.bottomAnchor, constant: 10).isActive = true
    }
    
    private func gymNameLabelLayout(){
        view.addSubview(gymNameLabel)
        gymNameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
        gymNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        gymNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        gymNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func daysLeftLabelLayout(){
        view.addSubview(daysLeftLabel)
        daysLeftLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5).isActive = true
        daysLeftLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        daysLeftLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        daysLeftLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    private func topViewLayout(){
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110).isActive = true
    }
    
    private func setupNavigationBar(){
        view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Schedule"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func collectionViewDelegates(){
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        slotsCollectionView.delegate = self
        slotsCollectionView.dataSource = self
    }
    
    private func calendarCollectionViewLayout(){
        topView.addSubview(calendarCollectionView)
        calendarCollectionView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calendarCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func slotsCollectionViewLayout(){
        view.addSubview(slotsCollectionView)
        slotsCollectionView.bottomAnchor.constraint(equalTo: bookButton.topAnchor, constant: -10).isActive = true
        slotsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        slotsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        slotsCollectionView.topAnchor.constraint(equalTo: sliderLine.bottomAnchor, constant: 10).isActive = true
    }
    
    //MARK:- Controller
    
    @objc func cancelSlotSelection(){
        slotsCollectionView.deselectAllItems()
        slotsCollectionView.reloadData()
    }
    
    @objc func handleBooking(){
        bookButton.showLoading()
        
        guard let fullName = userFullName else {
            bookButton.hideLoading()
            return
        }
        guard let userID = uid else {
            bookButton.hideLoading()
            return
        }
        guard let gymID = showSlotsData?.slots?.gym_id else {
            bookButton.hideLoading()
            return
        }
        guard let gymName = showSlotsData?.slots?.gym_name else {
            bookButton.hideLoading()
            return
        }
        guard let date = slotDate else {
            bookButton.hideLoading()
            return
        }
        guard let selectedSlotID = slotID else {
            bookButton.hideLoading()
            return
        }
        guard let slotTime = slotTime else {
            bookButton.hideLoading()
            return
        }
        guard let phone = userPhoneNumber else {
            bookButton.hideLoading()
            return
        }
        
        let url = "http://13.233.119.231:3000/bookSlot2"
        
        let parameters: [String : Any] = [
            "user_id": userID,
            "customer_name": fullName,
            "gym_id": gymID,
            "gym_name": gymName,
            "date": date,
            "slot_id": selectedSlotID,
            "time": slotTime,
            "booking_status": true,
            "check_in_status": false,
            "phone_no": phone
        ]
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                APIServices.sharedInstance.checkForSlotBooking(date: date, userID: userID) { (checkingForBooking) in
                    APIServices.sharedInstance.fetchGymSlots(date: date, userID: userID) { (showSlots) in
                        self.checkForBooking = checkingForBooking
                        self.showSlotsData = showSlots
                        
                    }
                }
                self.bookButton.hideLoading()
                break
            case .failure:
                print(Error.self)
                self.bookButton.hideLoading()
            }
        }
    }
    
    @objc func handleSlotCancelling(){
        guard let gymID = checkForBooking?.already_booked?.gym_id else {return}
        guard let date = checkForBooking?.already_booked?.date else {return}
        guard let objectID = checkForBooking?.already_booked?._id else {return}
        guard let userID = uid else {return}
        guard let selectedDate = slotDate else {return}
        
        let cancelURL = "http://13.233.119.231:3000/cancelSlot2"
        
        let parameters: [String : Any] = [
            "object_id": objectID,
            "gym_id": gymID,
            "date": date
        ]
        
        
        
        let alert = UIAlertController(title: "Cancel slot!", message: "Are you sure that you want to cancel the booked slot?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel slot", style: .default, handler: { (cancel) in
            self.activityView.startAnimating()
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(self.activityView)
            AF.request(cancelURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON {
                response in
                switch (response.result) {
                case .success:
                    APIServices.sharedInstance.checkForSlotBooking(date: selectedDate, userID: userID) { (checkingForBooking) in
                        APIServices.sharedInstance.fetchGymSlots(date: selectedDate, userID: userID) { (showSlots) in
                            self.checkForBooking = checkingForBooking
                            self.showSlotsData = showSlots
                            
                        }
                    }
                    self.activityView.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    self.activityView.removeFromSuperview()
                    break
                case .failure:
                    print(Error.self)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func showScannerVC(){
        let scannerVC = ScannerViewController()
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .denied:
            print("access denied")
            presentCameraSettings()
            break
        case .restricted:
            print("access restricted")
            presentCameraSettings()
            break
        case .authorized:
            print("access authorized")
            self.present(scannerVC, animated: true, completion: nil)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success{
                    print("permission granted")
                }else{
                    print("Permission not granted!")
                }
            }
            break
        default:
            break
        }
    }
    
    func presentCameraSettings(){
        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
        
    }
    //MARK:- Api Requests
    
    func chekcSlotBooking(){
        guard let uid = uid else {return}
        let date = rightNow.asString()
        APIServices.sharedInstance.checkForSlotBooking(date: date, userID: uid) { (checkBooking) in
            self.checkForBooking = checkBooking
        }
    }
    
    func showSlotDetails(){
        let date = rightNow.asString()
        guard let uid = uid else {return}
        APIServices.sharedInstance.fetchGymSlots(date: date, userID: uid) { (showSlotForBooking) in
            self.showSlotsData = showSlotForBooking
        }
        
    }
    
    func getUserFullName(){
        guard let uid = uid else {return}
        APIServices.sharedInstance.fetchUserData(uid: uid) { (userFullName) in
            guard let userFirst = userFullName.firstName else {return}
            guard let userLast = userFullName.lastName else {return}
            guard let userPhone = userFullName.phoneNumber else {return}
            self.userPhoneNumber = userPhone
            self.userFullName = ("\(userFirst) \(userLast)")
        }
    }
}
extension ScheduleViewController{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == calendarCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as? CalendarCell
            guard let passedDate = cell?.dateLabel.text else {return}
            guard let userID = uid else {return}
            APIServices.sharedInstance.checkForSlotBooking(date: passedDate, userID: userID) { (checkingForBooking) in
                APIServices.sharedInstance.fetchGymSlots(date: passedDate, userID: userID) { (showSlots) in
                    self.slotDate = passedDate
                    self.checkForBooking = checkingForBooking
                    self.showSlotsData = showSlots
                    
                }
            }
        }else if collectionView == slotsCollectionView{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.pulsate()
            guard let slotID = showSlotsData?.slots?.slots?[indexPath.item]._id else {return}
            guard let time = showSlotsData?.slots?.slots?[indexPath.item].start_time else {return}
            self.slotID = slotID
            self.slotTime = time
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarCollectionView{
            return 6
        }else{
            if let count = showSlotsData?.slots?.slots?.count{
                return count
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarCollectionView{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! CalendarCell
            cell.dateLabel.text = tomorrow(value: indexPath.item).asString()
            cell.dayLabel.text = dateFormatter.string(from: tomorrow(value: indexPath.item))
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Slots", for: indexPath) as! SlotsCell
            if let time = showSlotsData?.slots?.slots?[indexPath.item].start_time{
                cell.slotTimeLabel.text = time
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == calendarCollectionView{
            return CGSize(width: 70, height: 85)
        }else{
            return CGSize(width: 100, height: 40)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.removeAllAnimations()
    }
}

class SlotsCell: UICollectionViewCell {
    let slotTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        slotLabelLayout()
    }
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.systemGreen : UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            layer.borderWidth = isHighlighted ? 0 : 1
        }
    }
    
    override var isSelected: Bool{
        didSet{
            backgroundColor = isSelected ? UIColor.systemGreen :UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
            layer.borderWidth = isSelected ? 0 : 1
        }
    }
    
    private func slotLabelLayout(){
        addSubview(slotTimeLabel)
        slotTimeLabel.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
