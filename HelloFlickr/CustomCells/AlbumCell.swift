//
//  AlbumCell.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/4/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit

class AlbumCell: UICollectionViewCell {

    @IBOutlet weak var iv_Photo: UIImageView!
    @IBOutlet weak var downArrowHeightLC: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak var viewsCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        dropShadow()
    }
    
    class func reuseIdentifier()->String {
        return "AlbumCell"
    }
    
    public func populateCell(with photo:Photo) {
        self.iv_Photo.f22_setImage(url: photo.url, imageStyle: .squared)
        viewsCountLabel.text = "Views:\n"+(photo.views ?? "0")
        if photo.selected == true {
            self.downArrowHeightLC.constant = 25
        }else {
            self.downArrowHeightLC.constant = 0
        }
        self.imageViewBottomLC.constant = 10
        self.layoutIfNeeded()
    }
}

extension UIView {
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        layer.shadowRadius = 4.0
        layer.cornerRadius = 4.0
    }
}

