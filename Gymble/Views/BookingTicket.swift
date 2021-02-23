//
//  BookingTicket.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 30/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit

class BookingTicket: UIView {
    fileprivate let leftContainer: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.mainRed
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate let rightContainer: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.mainBlack
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        leftContainerLayout()
        rightContainerLayout()
    }
    
    private func leftContainerLayout(){
        addSubview(leftContainer)
        leftContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2, constant: -16).isActive = true
        leftContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        leftContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    }
    
    private func rightContainerLayout(){
        addSubview(rightContainer)
        rightContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightContainer.leadingAnchor.constraint(equalTo: leftContainer.trailingAnchor).isActive = true
        rightContainer.heightAnchor.constraint(equalToConstant: 150).isActive = true
        rightContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
