//
//  CollectionViewCell.swift
//  IndianBibles
//
//  Created by Admin on 25/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = frame.size.height / 2
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.75, green: 0.00, blue: 0.00, alpha: 1.00)
        
        cellTitle.font = UIFont.boldSystemFont(ofSize: 18)
        cellSubtitle.font = UIFont.boldSystemFont(ofSize: 10)
    }
    
}
