//
//  TimingsCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class TimingsCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var gymTimings: GymDetails?{
        didSet{
            self.morningTimeCV.reloadData()
            self.eveningTimeCV.reloadData()
        }
    }
    
    fileprivate let backViewMor: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    fileprivate let backViewEve: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    fileprivate let morningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.text = "Morning"
        return label
    }()
    
    fileprivate let eveningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Medium", size: 18)
        label.text = "Evening"
        return label
    }()
    
    private let morningTimeCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DetailsSlotsCell.self, forCellWithReuseIdentifier: "MorningSlots")
        return cv
    }()
    
    private let eveningTimeCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DetailsSlotsCell.self, forCellWithReuseIdentifier: "EveningSlots")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backViewMorningLayout()
        morningLabelLayout()
        morningCVLayout()
        backViewEveningLayout()
        eveningLabelLayout()
        eveningCVLayout()
        cvDelegates()
    }
    
    private func backViewMorningLayout(){
        addSubview(backViewMor)
        backViewMor.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backViewMor.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backViewMor.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        backViewMor.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func backViewEveningLayout(){
        addSubview(backViewEve)
        backViewEve.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backViewEve.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backViewEve.topAnchor.constraint(equalTo: morningTimeCV.bottomAnchor, constant: 5).isActive = true
        backViewEve.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func cvDelegates(){
        morningTimeCV.delegate = self
        morningTimeCV.dataSource = self
        eveningTimeCV.delegate = self
        eveningTimeCV.dataSource = self
    }
    
    private func eveningCVLayout(){
        addSubview(eveningTimeCV)
        eveningTimeCV.topAnchor.constraint(equalTo: eveningLabel.bottomAnchor, constant: 5).isActive = true
        eveningTimeCV.leadingAnchor.constraint(equalTo: eveningLabel.leadingAnchor).isActive = true
        eveningTimeCV.trailingAnchor.constraint(equalTo: eveningLabel.trailingAnchor).isActive = true
        eveningTimeCV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
    }
    
    private func morningCVLayout(){
        addSubview(morningTimeCV)
        morningTimeCV.topAnchor.constraint(equalTo: morningLabel.bottomAnchor, constant: 5).isActive = true
        morningTimeCV.leadingAnchor.constraint(equalTo: morningLabel.leadingAnchor).isActive = true
        morningTimeCV.trailingAnchor.constraint(equalTo: morningLabel.trailingAnchor).isActive = true
        morningTimeCV.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func morningLabelLayout(){
        backViewMor.addSubview(morningLabel)
        morningLabel.leadingAnchor.constraint(equalTo: backViewMor.leadingAnchor, constant: 16).isActive = true
        morningLabel.topAnchor.constraint(equalTo: backViewMor.topAnchor, constant: 2).isActive = true
        morningLabel.trailingAnchor.constraint(equalTo: backViewMor.trailingAnchor, constant: -16).isActive = true
    }
    
    private func eveningLabelLayout(){
        backViewEve.addSubview(eveningLabel)
        eveningLabel.leadingAnchor.constraint(equalTo: backViewEve.leadingAnchor, constant: 16).isActive = true
        eveningLabel.topAnchor.constraint(equalTo: backViewEve.topAnchor, constant: 2).isActive = true
        eveningLabel.trailingAnchor.constraint(equalTo: backViewEve.trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TimingsCell{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == morningTimeCV{
            if let count = gymTimings?.morning_slots?.count{
                return count
            }
        }
        else if collectionView == eveningTimeCV{
            if let eveningCount = gymTimings?.evening_slots?.count{
                return eveningCount
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == morningTimeCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorningSlots", for: indexPath) as! DetailsSlotsCell
            if let time = gymTimings?.morning_slots?[indexPath.item].start_time{
                cell.slotTimeLabel.text = time
            }
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EveningSlots", for: indexPath) as! DetailsSlotsCell
            if let time = gymTimings?.evening_slots?[indexPath.item].start_time{
                cell.slotTimeLabel.text = time
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 35)
    }
}

class DetailsSlotsCell: UICollectionViewCell {
    fileprivate let slotTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.text = "06:00"
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
    
    private func slotLabelLayout(){
        addSubview(slotTimeLabel)
        slotTimeLabel.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
