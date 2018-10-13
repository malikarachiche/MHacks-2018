//
//  CatVCCollectionCell.swift
//  MHacks StockX
//
//  Created by Nikhil Iyer on 10/13/18.
//  Copyright © 2018 Malik Arachiche. All rights reserved.
//

import UIKit
import Alamofire

class CatVCCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentbidLabel: UILabel!
    
    var product: Product!{
        didSet{
            
        }
    }
}
