//
//  UserProfileDetailsCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 02/09/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class UserProfileDetailsCell: UICollectionViewCell {
     let cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Next").withRenderingMode(.alwaysOriginal), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.mainBlack
        layer.cornerRadius = 5
        cellLabelLayout()
        editButtonLayout()
    }
    
    private func cellLabelLayout(){
        addSubview(cellLabel)
        cellLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        cellLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func editButtonLayout(){
        addSubview(editButton)
        editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        editButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        editButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
