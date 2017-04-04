//
//  PhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Fernando Geraldo Mantoan on 03/04/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    // MARK: Attributes
    // IBOutlet
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // Photo Alpha
    let PHOTO_LOADING_ALPHA = CGFloat(0.5)
    
    // MARK: Awake From NIB, to allow auto resizing
    override func awakeFromNib() {
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    }
    
    // MARK: Loading show/hide helpers
    func showLoading() {
        self.activityIndicator.startAnimating()
        self.photo.alpha = PHOTO_LOADING_ALPHA
    }
    
    func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.photo.alpha = 1
    }
    
    // MARK: Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        self.photo.image = UIImage(named: "placeholder")
        self.showLoading()
    }
}
