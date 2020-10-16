//
//  TimelineCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 29/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class TimelineCell: UICollectionViewCell {
     let thumbnailImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.image = #imageLiteral(resourceName: "correct")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
     let slotTime: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkInDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 15)
        label.textAlignment = .right
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkInTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textAlignment = .right
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bookingDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 15)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.mainBlack
        thumbnailImageLayout()
        slotTimeLayout()
        dateLabelLayout()
        checkInLayout()
        bookingDateLayout()
    }
    
    override func prepareForReuse() {
        thumbnailImage.image = nil
        slotTime.text = nil
        bookingDateLabel.text = nil
        checkInTimeLabel.text = nil
        checkInDateLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bookingDateLayout(){
        addSubview(bookingDateLabel)
        bookingDateLabel.leadingAnchor.constraint(equalTo: slotTime.leadingAnchor).isActive = true
        bookingDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        bookingDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func checkInLayout(){
        addSubview(checkInTimeLabel)
        checkInTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        checkInTimeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        checkInTimeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    private func slotTimeLayout(){
        addSubview(slotTime)
        slotTime.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 5).isActive = true
        slotTime.widthAnchor.constraint(equalToConstant: 100).isActive = true
        slotTime.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func dateLabelLayout(){
        addSubview(checkInDateLabel)
        checkInDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        checkInDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        checkInDateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func thumbnailImageLayout(){
        addSubview(thumbnailImage)
        thumbnailImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        thumbnailImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        thumbnailImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
