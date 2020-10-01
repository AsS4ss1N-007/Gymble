//
//  GymDetailsMenuBar.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
class GymDetailsMenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var gymDetailsCollectionViewMenuController: GymDetailsViewController?
    var menuBarSliderLeftAnchor: NSLayoutConstraint?
    let gymDetailsCollectionViewMenu: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GymDetailsMenuBarCell.self, forCellWithReuseIdentifier: "Tabs")
        return cv
    }()
    
    fileprivate let sliderLine: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        line.layer.cornerRadius = 1.5
        return line
    }()
    
    fileprivate let menuBarSlider: UIView = {
        let slider = UIView()
        slider.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        gymDetailsCollectionViewMenuLayout()
        gymDetailsCollectionViewMenuDelegates()
        menuBarSliderLayout()
        sliderLinesLayout()
        gymDetailsCollectionViewMenu.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: [])
    }
    
    private func sliderLinesLayout(){
        addSubview(sliderLine)
        sliderLine.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        sliderLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        sliderLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        sliderLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func menuBarSliderLayout(){
        addSubview(menuBarSlider)
        menuBarSliderLeftAnchor = menuBarSlider.leftAnchor.constraint(equalTo: leftAnchor)
        menuBarSliderLeftAnchor?.isActive = true
        menuBarSlider.heightAnchor.constraint(equalToConstant: 3).isActive = true
        menuBarSlider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
        menuBarSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func gymDetailsCollectionViewMenuDelegates(){
        gymDetailsCollectionViewMenu.delegate = self
        gymDetailsCollectionViewMenu.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func gymDetailsCollectionViewMenuLayout(){
        addSubview(gymDetailsCollectionViewMenu)
        gymDetailsCollectionViewMenu.topAnchor.constraint(equalTo: topAnchor).isActive = true
        gymDetailsCollectionViewMenu.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        gymDetailsCollectionViewMenu.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        gymDetailsCollectionViewMenu.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension GymDetailsMenuBar{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tabs", for: indexPath) as! GymDetailsMenuBarCell
        switch indexPath.item {
        case 0:
            cell.label.text = "Overview"
        case 1:
            cell.label.text = "Amenities"
        case 2:
            cell.label.text = "Trainers"
        case 3:
            cell.label.text = "Timings"
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: gymDetailsCollectionViewMenu.frame.size.width / 4, height: gymDetailsCollectionViewMenu.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gymDetailsCollectionViewMenuController?.scrollToGymDetailsMenuIndex(index: indexPath.item)
    }
}

class GymDetailsMenuBarCell: UICollectionViewCell {
    fileprivate let label: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        labelLayout()
    }
    
    override var isHighlighted: Bool {
        didSet {
            label.font = isHighlighted ? UIFont(name: "Roboto-Medium", size: 18) : UIFont(name: "Roboto-Regular", size: 18)
            label.textColor = isHighlighted ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            label.font = isSelected ? UIFont(name: "Roboto-Medium", size: 18) : UIFont(name: "Roboto-Regular", size: 18)
            label.textColor = isSelected ? UIColor.white.withAlphaComponent(1) : UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    private func labelLayout(){
        addSubview(label)
        label.frame = contentView.frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
