//
//  TimelineViewController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TimelineViewController: UIViewController{
    
    var timeLineDataArray: [TimelineModel]?{
        didSet{
            self.timelineCV.reloadData()
        }
    }
    
    private let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refresh.tintColor = UIColor.red
        return refresh
    }()
    
    fileprivate let noInternet: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "NOINTERNET"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let timelineCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TimelineCell.self, forCellWithReuseIdentifier: "Timeline")
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForInternetConnection()
    }
    
    func checkForInternetConnection(){
        if NetworkMonitor.shared.isConnected{
            configureUI()
        }else{
            noInternetImageLayout()
        }
    }
    
    func noInternetImageLayout(){
        view.addSubview(noInternet)
        noInternet.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        noInternet.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        noInternet.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        noInternet.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configureUI(){
        timelineCV.addSubview(refreshControl)
        getTimelineData()
        setupNavigationBar()
        timelineCVLayout()
        setupDelegates()
    }
    
    private func setupDelegates(){
        timelineCV.delegate = self
        timelineCV.dataSource = self
    }
    
    private func timelineCVLayout(){
        view.addSubview(timelineCV)
        timelineCV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        timelineCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        timelineCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        timelineCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavigationBar(){
        view.backgroundColor = .black
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Timeline"
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func getTimelineData(){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        APIServices.sharedInstance.getTimeLineData(uid: userID) { (timelineData: [TimelineModel]) in
            self.timeLineDataArray = timelineData
            
        }
    }
    
    @objc func didPullToRefresh(){
        refreshControl.endRefreshing()
        getTimelineData()
    }
    
}

extension TimelineViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = timeLineDataArray?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Timeline", for: indexPath) as! TimelineCell
        cell.thumbnailImage.image = #imageLiteral(resourceName: "correct")
        if let bookingDate = timeLineDataArray?[indexPath.item].booking_date{
            cell.bookingDateLabel.text = bookingDate.toDate().particularFormat()
        }
        if let checkInTime = timeLineDataArray?[indexPath.item].check_in_time{
            cell.checkInTimeLabel.text = checkInTime
        }
        
        if let checkInDate = timeLineDataArray?[indexPath.item].date{
            cell.checkInDateLabel.text = checkInDate.toDate().particularFormat()
        }
        
        if let slot = timeLineDataArray?[indexPath.item].time{
            cell.slotTime.text = slot
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 70)
    }
}
