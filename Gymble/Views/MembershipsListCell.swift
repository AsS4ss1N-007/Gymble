//
//  MembershipsListCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 01/10/20.
//

import UIKit
class MembershipListsCell: UICollectionViewCell {
    
    fileprivate let tickImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 1
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderColor = UIColor.darkGray.cgColor
        image.backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        return image
    }()
    
     let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
     let perMonthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Light", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
     let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate let rupeeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: "Roboto-Medium", size: 22)
        label.text = "₹"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 20
        backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        tickLayout()
        timeLabelLayout()
        perMonthLabelLayout()
        rateLabelLayout()
        rupeeLabelLayout()
    }
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? Colors.mainOrange : UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
            rupeeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            perMonthLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            rateLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            tickImage.image = isHighlighted ? UIImage(named: "Tick") : nil
            tickImage.layer.borderWidth = isHighlighted ? 0 : 1
        }
    }
    
    override var isSelected: Bool{
        didSet{
            backgroundColor = isSelected ? Colors.mainOrange : UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
            rupeeLabel.textColor = isSelected ? UIColor.white : UIColor.black
            perMonthLabel.textColor = isSelected ? UIColor.white : UIColor.black
            timeLabel.textColor = isSelected ? UIColor.white : UIColor.black
            rateLabel.textColor = isSelected ? UIColor.white : UIColor.black
            tickImage.image = isSelected ? UIImage(named: "Tick") : nil
            tickImage.layer.borderWidth = isSelected ? 0 : 1
        }
    }
    
    override func prepareForReuse() {
        backgroundColor = UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1)
        rupeeLabel.textColor = UIColor.black
        perMonthLabel.textColor = UIColor.black
        timeLabel.textColor = UIColor.black
        rateLabel.textColor = UIColor.black
        tickImage.image = nil
    }
    
    private func tickLayout(){
        addSubview(tickImage)
        tickImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tickImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        tickImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        tickImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func timeLabelLayout(){
        addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: tickImage.trailingAnchor, constant: 10).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2).isActive = true
    }
    
    private func perMonthLabelLayout(){
        addSubview(perMonthLabel)
        perMonthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        perMonthLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        perMonthLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true
    }
    
    private func rateLabelLayout(){
        addSubview(rateLabel)
        rateLabel.trailingAnchor.constraint(equalTo: perMonthLabel.leadingAnchor).isActive = true
        rateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func rupeeLabelLayout(){
        addSubview(rupeeLabel)
        rupeeLabel.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor).isActive = true
        rupeeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rupeeLabel.heightAnchor.constraint(equalToConstant: 29).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
