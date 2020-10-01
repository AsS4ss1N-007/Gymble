//
//  OverviewCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class OverviewCell: UICollectionViewCell {
    var gymDetails: GymDetails?{
        didSet{
            guard let gymName = gymDetails?.gym_name else {return}
            self.gymName.text = gymName
            
            guard let address = gymDetails?.address else {return}
            self.addressLabel.text = address
            
            guard let desc = gymDetails?.description else {return}
            self.descriptionText.text = desc
            
            guard let price = gymDetails?.subscription_fees else {return}
            self.joinButton.text = "\(price)/-"
        }
    }
    private let gymName: UILabel = {
        let name = UILabel()
        name.textAlignment = .left
        name.textColor = UIColor.white.withAlphaComponent(0.8)
        name.font = UIFont(name: "Roboto-Medium", size: 22)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    private let joinButton: UILabel = {
        let button = UILabel()
        button.layer.cornerRadius = 5
        button.backgroundColor = .clear
        button.textAlignment = .center
        button.textColor = UIColor.white
        button.layer.borderWidth = 0.5
        button.layer.borderColor = Colors.mainRed.cgColor
        button.font = UIFont(name: "Roboto-Medium", size: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let perMonthLabel: UILabel = {
        let label = UILabel()
        label.text = "per month"
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Light", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationPin: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "LocationPin"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addressLabel: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.isEditable = false
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentInset = UIEdgeInsets(top: -8, left: -4, bottom: 0, right: 0)
        return label
    }()
    
    private let descriptionHeader: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.textAlignment = .left
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let seperator: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return line
    }()
    
    private let descriptionText: UITextView = {
        let label = UITextView()
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.isEditable = false
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gymNameLabelLayout()
        joinButtonLayout()
        perMonthLabelLayout()
        locationPinLayout()
        addressLabelLayout()
        descriptionHeaderLayout()
        seperatorLayout()
        descriptionTextLayout()
    }
    private func seperatorLayout(){
        addSubview(seperator)
        seperator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        seperator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        seperator.topAnchor.constraint(equalTo: descriptionHeader.bottomAnchor, constant: 10).isActive = true
        seperator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    private func locationPinLayout(){
        addSubview(locationPin)
        locationPin.heightAnchor.constraint(equalToConstant: 13).isActive = true
        locationPin.widthAnchor.constraint(equalToConstant: 10).isActive = true
        locationPin.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: -5).isActive = true
        locationPin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
    
    private func joinButtonLayout(){
        addSubview(joinButton)
        joinButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        joinButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
    }
    
    
    private func gymNameLabelLayout(){
        addSubview(gymName)
        gymName.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        gymName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        gymName.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gymName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: 80).isActive = true
    }
    
    private func perMonthLabelLayout(){
        addSubview(perMonthLabel)
        perMonthLabel.topAnchor.constraint(equalTo: joinButton.bottomAnchor, constant: 2).isActive = true
        perMonthLabel.leadingAnchor.constraint(equalTo: joinButton.leadingAnchor).isActive = true
        perMonthLabel.trailingAnchor.constraint(equalTo: joinButton.trailingAnchor).isActive = true
    }
    
    private func addressLabelLayout(){
        addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: locationPin.topAnchor).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: locationPin.trailingAnchor, constant: 5).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: perMonthLabel.leadingAnchor, constant: -10).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func descriptionHeaderLayout(){
        addSubview(descriptionHeader)
        descriptionHeader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionHeader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        descriptionHeader.topAnchor.constraint(equalTo: locationPin.bottomAnchor, constant: 20).isActive = true
        descriptionHeader.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }
    
    private func descriptionTextLayout(){
        addSubview(descriptionText)
        descriptionText.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 5).isActive = true
        descriptionText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        descriptionText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        descriptionText.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
