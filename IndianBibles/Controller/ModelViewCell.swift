//
//  ModelViewCell.swift
//  IndianBibles
//
//  Created by Admin on 27/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class ModelViewCell: UICollectionViewCell {
    

    @IBOutlet weak var bibleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.size.height / 10
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red: 0.75, green: 0.00, blue: 0.00, alpha: 1.00)
        
    }
    
}
