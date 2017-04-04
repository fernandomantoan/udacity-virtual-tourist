//
//  PhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Fernando Geraldo Mantoan on 03/04/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    }
    
    func showLoading() {
        self.activityIndicator.startAnimating()
        self.photo.alpha = 0.5
    }
    
    func hideLoading() {
        self.activityIndicator.stopAnimating()
        self.photo.alpha = 1
    }
}
