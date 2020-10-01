//
//  TrainersCell.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
class TrainersCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var trainerData: GymDetails?{
        didSet{
            self.trainersCV.reloadData()
        }
    }
    
    private let trainersCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(Trainers.self, forCellWithReuseIdentifier: "Trainers")
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        trainersCVLayout()
        delegates()
    }
    
    private func delegates(){
        trainersCV.delegate = self
        trainersCV.dataSource = self
    }
    
    private func trainersCVLayout(){
        addSubview(trainersCV)
        trainersCV.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        trainersCV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        trainersCV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        trainersCV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrainersCell{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Trainers", for: indexPath) as! Trainers
        if let image = trainerData?.Trainers?[indexPath.item].trainer_image, let name = trainerData?.Trainers?[indexPath.item].trainer_name{
            cell.imageView.loadImageUsingUrlString(urlString: image)
            cell.nameLabel.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 150 * 9 / 16
        return CGSize(width: 150, height: height + 50)
    }
}

class Trainers: UICollectionViewCell {
    fileprivate let imageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.text = "Sangram Singh"
        return label
    }()
    
    fileprivate let proInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "Roboto-LightItalic", size: 18)
        label.text = "Male trainer"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        backgroundColor = Colors.mainBlack
        imageViewLayout()
        nameLabelLayout()
        proInLabelLayout()
    }
    
    fileprivate func imageViewLayout(){
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
    }
    
    fileprivate func nameLabelLayout(){
        addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    fileprivate func proInLabelLayout(){
        addSubview(proInLabel)
        proInLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 1).isActive = true
        proInLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        proInLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        proInLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
