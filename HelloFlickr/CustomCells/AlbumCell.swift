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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func reuseIdentifier()->String {
        return "AlbumCell"
    }
    
    public func populateCell(with photo:Photo) {
        self.iv_Photo.f22_setImage(url: photo.url!, imageStyle: .squared)
        if photo.selected == true {
            self.iv_Photo.layer.borderColor = UIColor.rgb(fromHex: 0x0041FF).cgColor
            self.iv_Photo.layer.borderWidth = 2.0
        }else {
            self.iv_Photo.layer.borderColor = UIColor.white.cgColor
            self.iv_Photo.layer.borderWidth = 0
        }
    }

}
