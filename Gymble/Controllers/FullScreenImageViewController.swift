//
//  FullScreenImageViewController.swift
//  GYMBLE_iOS_APP
//
//  Created by Sachin's Macbook Pro on 23/09/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
class FullScreenImageViewController: UIViewController{
    var gymID: String = ""
    var images: GymDetails?{
        didSet{
            imagesCV.reloadData()
        }
    }
    fileprivate let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    fileprivate let imagesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(FullScreenImage.self, forCellWithReuseIdentifier: "FULL")
        cv.isPagingEnabled = true
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImagesData()
        cvLayout()
        cvDelegates()
        cancelButtonLayout()
    }
    
    private func cvLayout(){
        view.addSubview(imagesCV)
        imagesCV.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imagesCV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imagesCV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imagesCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func cancelButtonLayout(){
        view.bringSubviewToFront(cancelButton)
        view.addSubview(cancelButton)
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }
    
    func cvDelegates(){
        imagesCV.delegate = self
        imagesCV.dataSource = self
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func getImagesData(){
        APIServices.sharedInstance.getGymDetails(gymID: gymID) { (getPhotos) in
            self.images = getPhotos
        }
    }
}

extension FullScreenImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = images?.images_array?.count{
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FULL", for: indexPath) as! FullScreenImage
        if let images = images?.images_array?[indexPath.item].image{
            cell.image.loadImageUsingUrlString(urlString: images)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imagesCV.frame.size.width, height: imagesCV.frame.size.height)
    }
}

class FullScreenImage: UICollectionViewCell {
    var image: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageLayout()
    }
    
    private func imageLayout(){
        addSubview(image)
        image.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
