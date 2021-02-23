//
//  AmenitiesCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class AmenitiesCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var gymDetails: GymDetails?{
        didSet{
            self.amenityCollectionView.reloadData()
        }
    }
    private let amenityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(Amenities.self, forCellWithReuseIdentifier: "Amenities")
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        amenityCVLayout()
        amenityCVDelegates()
    }
    
    private func amenityCVDelegates(){
        amenityCollectionView.delegate = self
        amenityCollectionView.dataSource = self
    }
    
    private func amenityCVLayout(){
        addSubview(amenityCollectionView)
        amenityCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        amenityCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        amenityCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        amenityCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AmenitiesCell{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = gymDetails?.Amenities?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Amenities", for: indexPath) as! Amenities
        if let image = gymDetails?.Amenities?[indexPath.item].amenity_image{
            cell.amenityImage.loadImageUsingUrlString(urlString: image)
        }
        if let labelText = gymDetails?.Amenities?[indexPath.item].amenity{
            cell.amenityLabel.text = labelText
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

class Amenities: UICollectionViewCell {
     let amenityImage: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.backgroundColor = Colors.mainBlack
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
     let amenityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        amenityImageLayout()
        amenityLabelLayout()
    }
    
    override func prepareForReuse() {
        amenityImage.image = nil
        amenityLabel.text = nil
    }
    
    private func amenityImageLayout(){
        addSubview(amenityImage)
        amenityImage.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        amenityImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        amenityImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        amenityImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
    }
    
    private func amenityLabelLayout(){
        addSubview(amenityLabel)
        amenityLabel.topAnchor.constraint(equalTo: amenityImage.bottomAnchor, constant: 5).isActive = true
        amenityLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        amenityLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        amenityLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
