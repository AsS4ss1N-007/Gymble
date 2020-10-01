//
//  HomeCollectionViewCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//
import UIKit
class HomeCollectionViewCell: UICollectionViewCell {
    var gym: GymsList?{
        didSet{
            if thumbnailImage.image != nil{
                return
            }else{
                setupThumbnailImage()
            }
            
            guard let nameLabel = gym?.gym_name else {return}
            self.gymName.text = nameLabel
            
            guard let address = gym?.address else {return}
            self.addressLabel.text = address
            
            guard let price = gym?.subscription_fees else {return}
            self.priceLabel.text = price
            
        }
    }
    
    private let thumbnailImage: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .clear
        return image
    }()
    
    private var gymName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.text = "Gold gym"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 15)
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "Kurukshetra University, Kurukshetra"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let locationPin: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "LocationPin"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        label.textColor = UIColor.white
        label.textAlignment = .right
        label.text = "1500/-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let perMonthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Light", size: 15)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .right
        label.text = "per month"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        backgroundColor = UIColor(red: 31/255, green: 31/255, blue: 31/255, alpha: 1)
        thumbnailImageLayout()
        gymNameLabelLayout()
        locationPinLayout()
        addressLabelLayout()
        priceLabelLayout()
        perMonthLabelLayout()
    }
    
    private func setupThumbnailImage() {
        if let thumbnailImageUrl = gym?.gym_image {
            thumbnailImage.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    private func thumbnailImageLayout(){
        addSubview(thumbnailImage)
        let height = (frame.size.width * (9 / 16))
        thumbnailImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        thumbnailImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        thumbnailImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        thumbnailImage.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func gymNameLabelLayout(){
        addSubview(gymName)
        gymName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        gymName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gymName.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 5).isActive = true
        gymName.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func locationPinLayout(){
        addSubview(locationPin)
        locationPin.heightAnchor.constraint(equalToConstant: 13).isActive = true
        locationPin.widthAnchor.constraint(equalToConstant: 10).isActive = true
        locationPin.topAnchor.constraint(equalTo: gymName.bottomAnchor, constant: 5).isActive = true
        locationPin.leadingAnchor.constraint(equalTo: gymName.leadingAnchor).isActive = true
    }
    
    private func addressLabelLayout(){
        addSubview(addressLabel)
        addressLabel.topAnchor.constraint(equalTo: locationPin.topAnchor).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/2, constant: 80).isActive = true
        addressLabel.leadingAnchor.constraint(equalTo: locationPin.trailingAnchor, constant: 5).isActive = true
    }
    
    private func priceLabelLayout(){
        addSubview(priceLabel)
        priceLabel.topAnchor.constraint(equalTo: gymName.topAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func perMonthLabelLayout(){
        addSubview(perMonthLabel)
        perMonthLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5).isActive = true
        perMonthLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor).isActive = true
        perMonthLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
