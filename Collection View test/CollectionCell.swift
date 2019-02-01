//
//  CollectionCell.swift
//  Collection View test
//
//  Created by Przemek on 2/1/19.
//  Copyright © 2019 Przemek. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    func setImage(ofName: String) {
        cellImageView.image = UIImage(named: ofName)
    }
    
}
