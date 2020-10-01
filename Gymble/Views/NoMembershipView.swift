//
//  NoMembershipView.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import Foundation
import UIKit
class NoMembershipView: UIView {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewLayout()
        
    }
    
    private func imageViewLayout(){
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
