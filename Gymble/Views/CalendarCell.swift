//
//  CalendarCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    let darkGray = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
     let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "21"
        label.font = UIFont(name: "Roboto-Medium", size: 40)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Wed"
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = darkGray
        layer.cornerRadius = 5
        dateLabelLayout()
        dayLabelLayout()
    }
    
    override var isHighlighted: Bool {
        didSet {
            dateLabel.textColor = isHighlighted ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.6)
            dayLabel.textColor = isHighlighted ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.6)
            contentView.backgroundColor = isHighlighted ? Colors.mainOrange : darkGray
            contentView.layer.cornerRadius = isHighlighted ? 5 : 5
        }
    }
    
    override var isSelected: Bool {
        didSet {
            dateLabel.textColor = isSelected ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.6)
            dayLabel.textColor = isSelected ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.6)
            contentView.backgroundColor = isSelected ? Colors.mainOrange : darkGray
            contentView.layer.cornerRadius = isSelected ? 5 : 5
        }
    }
    
    private func dateLabelLayout(){
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
    }
    
    private func dayLabelLayout(){
        addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
