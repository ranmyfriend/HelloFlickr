//
//  AlbumDetailCell.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/4/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit

class AlbumDetailCell: UICollectionViewCell {

    @IBOutlet weak var lbl_title: UnderlinedLabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lc_upwardImgeViewLeading: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func reuseIdentifier()->String {
        return "AlbumDetailCell"
    }
    
    public func populateCell(with photo:Photo) {
        if let place = photo.place {
            let nameArray = place.name?.components(separatedBy: ",")
            self.lbl_title.text = photo.title! + " " + (nameArray?.last)! 
        }else {
            self.lbl_title.text = photo.title
        }
        self.lbl_description.text = photo.description
        
    }

}


class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.characters.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
}
