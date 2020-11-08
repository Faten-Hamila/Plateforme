//
//  MyCollectionViewCell.swift
//  Plateforme
//
//  Created by Faten's MacBook  on 22/09/2020.
//  Copyright © 2020 faten hamila. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var legendLabel : UILabel!
    static let identifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure (with image:UIImage , description : String  ){
        imageView.image = image
        legendLabel.text = description
       
    }
    static func nib() -> UINib{
        return UINib(nibName: "MyCollectionViewCell", bundle: nil)
    }

}
